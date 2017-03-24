import XCTest
@testable import numsw

class MatrixMultiplyTests: XCTestCase {
    
    func testMultiply() {
        do {
            let a = Matrix(rows: 2, columns: 2, elements: [1.0, 2.0, 1.0, 2.0])
            let b = Matrix(rows: 2, columns: 2, elements: [1.0, 0.0, 0.0, 1.0])
            
            let c = multiply(a, b)
            
            XCTAssertEqual(c.elements, [1.0, 2.0, 1.0, 2.0])
        }
        do {
            let a = Matrix<Double>([[0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10, 11]])
            let b = Matrix<Double>([[10, 6, 9], [0, 2, 3], [8, 5, 7], [11, 4, 1]])
            
            let c = multiply(a, b)
            
            XCTAssertEqual(c, Matrix([[ 49, 24, 20],
                                      [165, 92, 100],
                                      [281, 160, 180]]))
        }
    }
    
    func testMultiplyOperator() {
        let a = Matrix(rows: 2, columns: 2, elements: [1.0, 2.0, 1.0, 2.0])
        let b = Matrix(rows: 2, columns: 2, elements: [1.0, 0.0, 0.0, 1.0])
        
        let c = a * b
        
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
            ("testMultiplyOperator", testMultiplyOperator)
        ]
    }
}
