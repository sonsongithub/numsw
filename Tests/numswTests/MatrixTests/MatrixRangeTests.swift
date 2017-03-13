import XCTest
@testable import numsw

class MatrixRangeTests: XCTestCase {
    
    func testRange() {
        let mat = Matrix<Int>.range(from: 0, to: 10, stride: 2)
        XCTAssertEqual(mat.elements, [0, 2, 4, 6, 8])
    }
    
    func testLinspace() {
        let mat = Matrix<Double>.linspace(low: 0, high: 8, count: 5)
        XCTAssertEqual(mat.elements, [0, 2, 4, 6, 8])
    }
    
    static var allTests: [(String, (MatrixRangeTests) -> () throws -> Void)] {
        return [
            ("testRange", testRange),
            ("testLinspace", testLinspace),
        ]
    }
}
