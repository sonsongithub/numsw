
import XCTest
@testable import numsw

class MatrixMultiplyTests: XCTestCase {
    
    func testMultiply() {
        let a = Matrix(rows: 2, columns: 2, elements: [1.0, 2.0, 1.0, 2.0])
        let b = Matrix(rows: 2, columns: 2, elements: [1.0, 0.0, 0.0, 1.0])
        
        let c = multiply(a, b)
        
        XCTAssertEqual(c.elements, [1.0, 2.0, 1.0, 2.0])
    }
    
    #if os(iOS) || os(OSX)
    
    func testMultiplyAccelerate() {
        let a = Matrix(rows: 2, columns: 2, elements: [1.0, 2.0, 1.0, 2.0])
        let b = Matrix(rows: 2, columns: 2, elements: [1.0, 0.0, 0.0, 1.0])
        
        let c = multiplyAccelerate(a, b)
        
        XCTAssertEqual(c.elements, [1.0, 2.0, 1.0, 2.0])
    }
    
    #endif
    
    static var allTests: [(String, (MatrixMultiplyTests) -> () throws -> Void)] {
        return [
            ("testMultiply", testMultiply),
        ]
    }
}
