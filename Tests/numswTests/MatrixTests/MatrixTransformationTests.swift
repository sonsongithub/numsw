import XCTest
@testable import numsw

class MatrixTransformationTests: XCTestCase {
    
    func testReshape() {
        let a = Matrix<Int>.eye(4)
        XCTAssertEqual(a.reshaped(rows: 2, columns: 8), Matrix([[1, 0, 0, 0, 0, 1, 0, 0], [0, 0, 1, 0, 0, 0, 0, 1]]))
    }
    
    static var allTests: [(String, (MatrixTransformationTests) -> () throws -> Void)] {
        return [
            ("testReshape", testReshape),
        ]
    }
    
}
