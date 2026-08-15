import Cocoa
import SwiftUI

/// Gestiona una ventana de superposición por cada pantalla conectada,
/// mostrando `LockOverlayView` mientras el "Modo Limpieza" está activo.
final class OverlayWindowController {
    private let inputBlocker: InputBlocker
    private var windows: [NSWindow] = []
    private var screenObserver: NSObjectProtocol?

    init(inputBlocker: InputBlocker) {
        self.inputBlocker = inputBlocker

        inputBlocker.onUnlockRequested = { [weak self] in
            self?.hide()
            self?.inputBlocker.stopBlocking()
        }

        screenObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self, self.inputBlocker.isBlocking else { return }
            self.rebuildWindows()
        }
    }

    deinit {
        if let screenObserver {
            NotificationCenter.default.removeObserver(screenObserver)
        }
    }

    func show() {
        rebuildWindows()
    }

    func hide() {
        windows.forEach { $0.orderOut(nil) }
        windows.removeAll()
    }

    private func rebuildWindows() {
        hide()

        for screen in NSScreen.screens {
            let window = NSWindow(
                contentRect: screen.frame,
                styleMask: [.borderless],
                backing: .buffered,
                defer: false,
                screen: screen
            )

            window.isOpaque = false
            window.backgroundColor = .clear
            window.level = .screenSaver
            window.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary, .ignoresCycle]
            window.ignoresMouseEvents = true
            window.hasShadow = false
            window.isReleasedWhenClosed = false

            let hostingView = NSHostingView(rootView: LockOverlayView(inputBlocker: inputBlocker))
            hostingView.frame = window.contentRect(forFrameRect: window.frame)
            window.contentView = hostingView

            window.setFrame(screen.frame, display: true)
            window.orderFrontRegardless()

            windows.append(window)
        }
    }
}
