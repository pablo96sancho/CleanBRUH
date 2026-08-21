import Cocoa

/// Gestiona el icono y el menú desplegable en la barra de estado de macOS.
final class MenuBarManager: NSObject {
    private let statusItem: NSStatusItem
    private let inputBlocker: InputBlocker
    private let overlayController: OverlayWindowController

    private let startCleaningItem = NSMenuItem()
    private let holdSpaceUnlockItem = NSMenuItem()

    init(inputBlocker: InputBlocker, overlayController: OverlayWindowController) {
        self.inputBlocker = inputBlocker
        self.overlayController = overlayController
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        super.init()

        inputBlocker.onBlockingStateChanged = { [weak self] in
            self?.updateCleaningMenuTitle()
        }

        configureStatusItem()
        configureMenu()
    }

    private func configureStatusItem() {
        statusItem.button?.image = NSImage(
            systemSymbolName: "sparkles",
            accessibilityDescription: "CleanBRUH"
        )
    }

    private func configureMenu() {
        let menu = NSMenu()

        updateCleaningMenuTitle()
        startCleaningItem.target = self
        startCleaningItem.action = #selector(toggleCleaningMode)
        menu.addItem(startCleaningItem)

        menu.addItem(.separator())

        holdSpaceUnlockItem.title = "Desbloqueo: mantener barra espaciadora (3 s)"
        holdSpaceUnlockItem.isEnabled = false
        menu.addItem(holdSpaceUnlockItem)

        menu.addItem(.separator())

        let checkPermissionsItem = NSMenuItem(
            title: "Comprobar Permisos de Accesibilidad",
            action: #selector(checkAccessibilityPermissions),
            keyEquivalent: ""
        )
        checkPermissionsItem.target = self
        menu.addItem(checkPermissionsItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(title: "Salir", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    private func updateCleaningMenuTitle() {
        startCleaningItem.title = "Iniciar Limpieza"
        startCleaningItem.state = .off
    }

    private func updateUnlockMethodMenuState() {
        holdSpaceUnlockItem.state = .on
    }

    @objc private func selectHoldSpaceUnlockMethod() {
        inputBlocker.unlockMethod = .holdSpace
        updateUnlockMethodMenuState()
    }

    @objc private func toggleCleaningMode() {
        if inputBlocker.isBlocking {
            inputBlocker.stopBlocking()
            overlayController.hide()
            updateCleaningMenuTitle()
            return
        }

        guard InputBlocker.hasAccessibilityPermission(promptIfNeeded: false) else {
            presentAccessibilityAlert()
            updateCleaningMenuTitle()
            return
        }

        overlayController.show()
        let started = inputBlocker.startBlocking()

        if started {
            updateCleaningMenuTitle()
        } else {
            overlayController.hide()
            updateCleaningMenuTitle()
            presentAccessibilityAlert()
        }
    }

    @objc private func checkAccessibilityPermissions() {
        let granted = InputBlocker.hasAccessibilityPermission(promptIfNeeded: true)
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = granted ? "Permisos concedidos" : "Permisos de Accesibilidad necesarios"
        alert.informativeText = granted
            ? "CleanBRUH tiene acceso de Accesibilidad y puede bloquear el teclado, el trackpad y el ratón."
            : "Para bloquear el teclado, el trackpad y el ratón, concede acceso a CleanBRUH en Ajustes del Sistema → Privacidad y seguridad → Accesibilidad."
        alert.addButton(withTitle: "OK")
        if !granted { alert.addButton(withTitle: "Abrir Ajustes del Sistema") }

        if alert.runModal() == .alertSecondButtonReturn {
            InputBlocker.openAccessibilityPreferences()
        }
    }

    private func presentAccessibilityAlert() {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "No se puede iniciar el Modo Limpieza"
        alert.informativeText = "CleanBRUH necesita permisos de Accesibilidad para bloquear el teclado, el trackpad y el ratón. Concédelos en Ajustes del Sistema y vuelve a intentarlo."
        alert.addButton(withTitle: "Abrir Ajustes del Sistema")
        alert.addButton(withTitle: "Cancelar")

        if alert.runModal() == .alertFirstButtonReturn {
            InputBlocker.openAccessibilityPreferences()
        }
    }

    @objc private func quit() {
        inputBlocker.stopBlocking()
        NSApplication.shared.terminate(nil)
    }
}
