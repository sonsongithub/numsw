
import XCTest
@testable import numsw

class MatrixSubscriptTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testElementSubscript() {
        var mat = Matrix(rows: 3, columns: 3, elements: Array(0..<9).map(Double.init))
        
        XCTAssertEqual(mat[0, 0], 0)
        XCTAssertEqual(mat[0, 1], 1)
        XCTAssertEqual(mat[1, 0], 3)
        
    }
    
    func testRowSubscript() {
        var mat = Matrix(rows: 3, columns: 3, elements: Array(0..<9).map(Double.init))
        
        XCTAssertEqual(mat[0].elements, [0, 1, 2])
        
        mat[0] = Matrix(rows: 1, columns: 3, elements: Array(10..<13).map(Double.init))
        
        XCTAssertEqual(mat[0].elements, [10, 11, 12])
    }
}
