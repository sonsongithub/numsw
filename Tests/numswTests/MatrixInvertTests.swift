
import XCTest
@testable import numsw

class MatrixInvertTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDoubleInvert() {
        let mat = Matrix(rows: 2, columns: 2, elements: [0.0, 1.0, 2.0, 3.0])
        let inv = mat.inverted()
        XCTAssertEqual(inv.elements, [-1.5, 0.5, 1, 0])
    }
    
    func testFloatInvert() {
        let mat = Matrix<Float>(rows: 2, columns: 2, elements: [0.0, 1.0, 2.0, 3.0])
        let inv = mat.inverted()
        XCTAssertEqual(inv.elements, [-1.5, 0.5, 1, 0])
    }
}
