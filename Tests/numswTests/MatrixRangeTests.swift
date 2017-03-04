
import XCTest
@testable import numsw

class MatrixRangeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRange() {
        let mat = Matrix.range(from: 0, to: 10, stride: 2)
        XCTAssertEqual(mat.elements, [0.0, 2, 4, 6, 8])
    }
    
    func testLinspace() {
        let mat = Matrix.linspace(from: 0, to: 8, count: 5)
        XCTAssertEqual(mat.elements, [0.0, 2, 4, 6, 8])
    }
    
}
