import XCTest
@testable import numsw

class MatrixTransposeTests: XCTestCase {
    
    func testTranspose() {
        let mat = Matrix(rows: 2, columns: 2, elements: [0.0, 1.0, 2.0, 3.0])
        let inv = mat.transposed()
        XCTAssertEqual(inv.elements, [0.0, 2.0, 1.0, 3.0])
    }
    
    static var allTests: [(String, (MatrixTransposeTests) -> () throws -> Void)] {
        return [
            ("testTranspose", testTranspose),
        ]
    }
}
