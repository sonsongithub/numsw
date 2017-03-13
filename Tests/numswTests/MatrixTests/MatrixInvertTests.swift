import XCTest
@testable import numsw

class MatrixInvertTests: XCTestCase {
    
    #if os(iOS) || os(OSX)
    
    func testDoubleInvert() {
        let mat = Matrix(rows: 2, columns: 2, elements: [0.0, 1.0, 2.0, 3.0])
        let inv = mat.inverted()
        XCTAssertEqual(inv.elements, [-1.5, 0.5, 1, 0])
    }
    
    #endif
    
    static var allTests: [(String, (MatrixInvertTests) -> () throws -> Void)] {
        return [
            // ("testDoubleInvert", testDoubleInvert),
        ]
    }
}
