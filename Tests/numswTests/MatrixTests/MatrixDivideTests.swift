import XCTest
@testable import numsw

class MatrixDivideTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDivide() {
        let mat = Matrix(rows: 2, columns: 2, elements: [0.0, 2.0, 4.0, 6.0])
        let x = mat / 2
        
        XCTAssertEqual(x.elements, [0.0, 1.0, 2.0, 3.0])
    }
    
    func testDivide2() {
        let mat = Matrix(rows: 2, columns: 2, elements: [1.0, 2.0, 4.0, 8.0])
        let x = 8 / mat
        
        XCTAssertEqual(x.elements, [8.0, 4.0, 2.0, 1.0])
        
    }
    
    static var allTests: [(String, (MatrixDivideTests) -> () throws -> Void)] {
        return [
            ("testDivide", testDivide),
            ("testDivide2", testDivide2),
        ]
    }
}
