import Foundation
import XCTest

final class InfoPlistBundleConfigurationTests: XCTestCase {
    func testBundleConfigMatchesMenuBarAppRequirements() throws {
        let rootURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let infoPlistURL = rootURL.appendingPathComponent("Sources/CleanBRUH/Resources/Info.plist")
        let data = try Data(contentsOf: infoPlistURL)
        let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any]

        XCTAssertEqual(plist?["CFBundleIdentifier"] as? String, "com.pablo.CleanBRUH")
        XCTAssertEqual(plist?["LSUIElement"] as? Bool, true)
    }
}
