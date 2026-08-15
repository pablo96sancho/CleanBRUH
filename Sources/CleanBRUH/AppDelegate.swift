import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var inputBlocker: InputBlocker!
    private var overlayController: OverlayWindowController!
    private var menuBarManager: MenuBarManager!

    func applicationDidFinishLaunching(_ notification: Notification) {
        inputBlocker = InputBlocker()
        overlayController = OverlayWindowController(inputBlocker: inputBlocker)
        menuBarManager = MenuBarManager(
            inputBlocker: inputBlocker,
            overlayController: overlayController
        )
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }
}
