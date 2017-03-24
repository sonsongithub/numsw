import XCTest
@testable import numsw

class MatrixCreationTests: XCTestCase {
    
    func testInit() {
        let a = Matrix<Double>([[0, 1], [1, 2], [2, 3]])
        XCTAssertEqual(a, Matrix<Double>(rows: 3, columns: 2, elements: [0, 1, 1, 2, 2, 3]))
    }
    
    func testZeros() {
        let a = Matrix<Double>.zeros(rows: 2, columns: 3)
        XCTAssertEqual(a, Matrix([[0, 0, 0], [0, 0, 0]]))
    }
    
    func testOnes() {
        let a = Matrix<Double>.ones(rows: 2, columns: 3)
        XCTAssertEqual(a, Matrix([[1, 1, 1], [1, 1, 1]]))
    }
    
    func testEye() {
        let a = Matrix<Double>.eye(3)
        XCTAssertEqual(a, Matrix([[1, 0, 0], [0, 1, 0], [0, 0, 1]]))
    }
    
    static var allTests: [(String, (MatrixCreationTests) -> () throws -> Void)] {
        return [
            ("testInit", testInit),
            ("testZeros", testZeros),
            ("testOnes", testOnes),
            ("testEye", testEye)
        ]
    }
}
