import Cocoa
import Combine
import ApplicationServices

/// Captura y descarta los eventos de teclado, trackpad y ratón del sistema
/// mientras el "Modo Limpieza" está activo, usando un Event Tap de
/// CoreGraphics a nivel de sesión (`.cgSessionEventTap`).
///
/// También detecta, dentro del propio tap, el gesto de mantener pulsada
/// la BARRA ESPACIADORA durante `holdDuration` segundos para desbloquear.
final class InputBlocker: ObservableObject {

    enum UnlockMethod {
        case holdSpace
        case commandEscape
    }

    // MARK: - Estado publicado (para la UI)

    @Published private(set) var isBlocking = false
    @Published private(set) var holdProgress: Double = 0.0
    var unlockMethod: UnlockMethod = .holdSpace

    /// Se invoca cuando cambia el estado de bloqueo para que la UI pueda sincronizarse.
    var onBlockingStateChanged: (() -> Void)?

    /// Se invoca cuando el usuario completa el gesto de desbloqueo.
    var onUnlockRequested: (() -> Void)?

    // MARK: - Configuración del gesto de desbloqueo

    /// Código de tecla de la BARRA ESPACIADORA en el layout estándar de macOS.
    private let unlockKeyCode: CGKeyCode = 49
    private let holdDuration: TimeInterval = 3.0

    // MARK: - Internos del Event Tap

    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var holdStartTime: CFAbsoluteTime?
    private var progressTimer: Timer?

    private let eventMask: CGEventMask =
        (1 << CGEventType.keyDown.rawValue) |
        (1 << CGEventType.keyUp.rawValue) |
        (1 << CGEventType.flagsChanged.rawValue) |
        (1 << CGEventType.mouseMoved.rawValue) |
        (1 << CGEventType.leftMouseDown.rawValue) |
        (1 << CGEventType.leftMouseUp.rawValue) |
        (1 << CGEventType.leftMouseDragged.rawValue) |
        (1 << CGEventType.rightMouseDown.rawValue) |
        (1 << CGEventType.rightMouseUp.rawValue) |
        (1 << CGEventType.rightMouseDragged.rawValue) |
        (1 << CGEventType.otherMouseDown.rawValue) |
        (1 << CGEventType.otherMouseUp.rawValue) |
        (1 << CGEventType.otherMouseDragged.rawValue) |
        (1 << CGEventType.scrollWheel.rawValue)

    // MARK: - Permisos de Accesibilidad

    /// Comprueba si la app tiene permisos de Accesibilidad.
    /// - Parameter promptIfNeeded: si es `true`, macOS muestra el diálogo
    ///   del sistema pidiendo al usuario que conceda el permiso.
    @discardableResult
    static func hasAccessibilityPermission(promptIfNeeded: Bool = false) -> Bool {
        let promptKey = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
        let options: [String: Bool] = [promptKey: promptIfNeeded]
        let granted = AXIsProcessTrustedWithOptions(options as CFDictionary)

        if !granted {
            openAccessibilityPreferences()
        }

        return granted
    }

    /// Abre Ajustes del Sistema → Privacidad y seguridad → Accesibilidad.
    static func openAccessibilityPreferences() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }

    // MARK: - Iniciar / Detener bloqueo

    /// Activa la captura de eventos del sistema.
    /// - Returns: `false` si no se pudo crear el Event Tap (por ejemplo,
    ///   por falta de permisos de Accesibilidad).
    @discardableResult
    func startBlocking() -> Bool {
        guard !isBlocking else { return true }

        guard InputBlocker.hasAccessibilityPermission(promptIfNeeded: true) else {
            return false
        }

        let selfPointer = Unmanaged.passUnretained(self).toOpaque()

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: eventTapCallback,
            userInfo: selfPointer
        ) else {
            return false
        }

        eventTap = tap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)

        isBlocking = true
        onBlockingStateChanged?()
        return true
    }

    /// Desactiva la captura y libera el Event Tap.
    func stopBlocking() {
        guard isBlocking else { return }

        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
        }
        if let source = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetMain(), source, .commonModes)
        }

        eventTap = nil
        runLoopSource = nil
        isBlocking = false
        onBlockingStateChanged?()

        resetHoldState()
    }

    deinit {
        stopBlocking()
    }

    // MARK: - Lógica de "mantener pulsado para desbloquear"

    fileprivate func handleUnlockKeyDown() {
        guard holdStartTime == nil else { return }
        holdStartTime = CFAbsoluteTimeGetCurrent()

        progressTimer?.invalidate()
        let timer = Timer(timeInterval: 1.0 / 30.0, repeats: true) { [weak self] _ in
            self?.updateHoldProgress()
        }
        RunLoop.main.add(timer, forMode: .common)
        progressTimer = timer
    }

    fileprivate func handleUnlockKeyUp() {
        resetHoldState()
    }

    private func updateHoldProgress() {
        guard let start = holdStartTime else { return }
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        let progress = min(elapsed / holdDuration, 1.0)
        holdProgress = progress

        if progress >= 1.0 {
            resetHoldState()
            onUnlockRequested?()
        }
    }

    private func resetHoldState() {
        holdStartTime = nil
        progressTimer?.invalidate()
        progressTimer = nil
        holdProgress = 0.0
    }

    // MARK: - Procesamiento de eventos (llamado desde el callback en C)

    fileprivate func process(type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        // Si el sistema desactiva el tap (timeout o intervención del
        // usuario), lo reactivamos de inmediato para no perder el bloqueo.
        if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
            if let tap = eventTap {
                CGEvent.tapEnable(tap: tap, enable: true)
            }
            return nil
        }

        if type == .keyDown || type == .keyUp {
            let keyCode = CGKeyCode(event.getIntegerValueField(.keyboardEventKeycode))

            if unlockMethod == .holdSpace && keyCode == unlockKeyCode {
                type == .keyDown ? handleUnlockKeyDown() : handleUnlockKeyUp()
            }

            if unlockMethod == .commandEscape && type == .keyDown {
                let flags = event.flags
                let isCommandEscape = flags.contains(.maskCommand) && keyCode == 53
                if isCommandEscape {
                    resetHoldState()
                    onUnlockRequested?()
                }
            }
        }

        // Devolver `nil` descarta el evento: no llega a ninguna app,
        // incluida la nuestra.
        return nil
    }
}

/// Callback en C requerido por `CGEvent.tapCreate`. No puede capturar
/// contexto Swift, así que recuperamos la instancia de `InputBlocker`
/// a través de `userInfo`.
private func eventTapCallback(
    proxy: CGEventTapProxy,
    type: CGEventType,
    event: CGEvent,
    refcon: UnsafeMutableRawPointer?
) -> Unmanaged<CGEvent>? {
    guard let refcon else {
        return Unmanaged.passRetained(event)
    }
    let blocker = Unmanaged<InputBlocker>.fromOpaque(refcon).takeUnretainedValue()
    return blocker.process(type: type, event: event)
}
