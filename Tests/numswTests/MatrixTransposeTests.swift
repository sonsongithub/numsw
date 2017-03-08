import XCTest
@testable import numsw

class MatrixTransposeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTranspose() {
        let mat = Matrix(rows: 2, columns: 2, elements: [0.0, 1.0, 2.0, 3.0])
        let inv = mat.transposed()
        XCTAssertEqual(inv.elements, [0.0, 2.0, 1.0, 3.0])
    }
    
}
