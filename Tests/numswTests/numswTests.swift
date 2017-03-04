import XCTest
@testable import numsw

class numswTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(numsw().text, "Hello, World!")
    }


    static var allTests : [(String, (numswTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
