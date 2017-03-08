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
    
    func testSubmatrixSubscript() {
        var mat = Matrix(rows: 3, columns: 3, elements: Array(0..<9).map(Double.init))
        
        XCTAssertEqual(mat[nil, nil].elements, [0.0, 1, 2, 3, 4, 5, 6, 7, 8])
        XCTAssertEqual(mat[[1, 2], nil].elements, [3.0, 4, 5, 6, 7, 8])
        XCTAssertEqual(mat[nil, [1, 2]].elements, [1.0, 2.0, 4, 5, 7, 8])
        
        mat[[1, 2], nil] = Matrix(rows: 2, columns: 3, elements: [Double](repeating: 0, count: 6))
        XCTAssertEqual(mat.elements, [0.0, 1, 2, 0, 0, 0, 0, 0, 0])
    }
    
    func testAddAssign() {
        var mat2 = Matrix.zeros(rows: 3, columns: 3)
        mat2[[0, 1], nil] += Matrix.ones(rows: 2, columns: 3)
        mat2[nil, [1]] += Matrix.ones(rows: 3, columns: 1)
        XCTAssertEqual(mat2.elements, [1.0, 2, 1, 1, 2, 1, 0, 1, 0])
    }
    
    func testMultAssign() {
        var mat = Matrix(rows: 3, columns: 3, elements: Array(0..<9).map(Double.init))
        
        mat[[0, 1], [0, 1]] *= 4
        XCTAssertEqual(mat.elements, [0.0, 4, 2, 12, 16, 5, 6, 7, 8])
        
        mat[[2], nil] .*= Matrix([[1, 2, 3]])
        XCTAssertEqual(mat.elements, [0.0, 4, 2, 12, 16, 5, 6, 14, 24])
    }
}
