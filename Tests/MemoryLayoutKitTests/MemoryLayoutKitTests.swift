import XCTest
import MemoryLayoutKit

class MemoryLayoutKitTests: XCTestCase {
    func testCharPointerConstPointer() {
        var array: [String]? = ["first", "second", "third"]
        let pointer = try? array?.cArray(using: .utf8)
        array = nil
        XCTAssert(String(describing: pointer) == "Optional(Optional([first][second][third]))" , "Incorrect value.")
        pointer??.deallocator()
    }
    
    static var allTests = [
        ("testCharPointerConstPointer", testCharPointerConstPointer),
        ]
}
