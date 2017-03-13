
import XCTest
@testable import numsw

class MatrixArithmeticTests: XCTestCase {
    
    func testUnaryPlus() {
        let a = Matrix([[1, 2, 3], [6, 5, 4]])
        XCTAssertEqual(unaryPlus(a), Matrix([[1, 2, 3], [6, 5, 4]]))
    }
    
    func testUnaryMinus() {
        let a = Matrix([[1, 2, 3], [6, 5, 4]])
        XCTAssertEqual(unaryMinus(a), Matrix([[-1, -2, -3], [-6, -5, -4]]))
    }
    
    func testAdd() {
        
        let a = Matrix([[1, 2, 3], [6, 5, 4]])
        
        XCTAssertEqual(add(a, 1), Matrix([[2, 3, 4], [7, 6, 5]]))
        XCTAssertEqual(add(1, a), Matrix([[2, 3, 4], [7, 6, 5]]))
        
        let b = Matrix([[0, 1, 2], [3, 4, 5]])
        XCTAssertEqual(add(a, b), Matrix([[1, 3, 5], [9, 9, 9]]))
    }
    
    func testSubtract() {
        
        let a = Matrix([[1, 2, 3], [6, 5, 4]])
        
        XCTAssertEqual(subtract(a, 1), Matrix([[0, 1, 2], [5, 4, 3]]))
        XCTAssertEqual(subtract(1, a), Matrix([[0, -1, -2], [-5, -4, -3]]))
        
        let b = Matrix([[0, 1, 2], [3, 4, 5]])
        XCTAssertEqual(subtract(a, b), Matrix([[1, 1, 1], [3, 1, -1]]))
    }
    
    func testElementWiseProduct() {
        
        let a = Matrix([[1, 2, 3], [6, 5, 4]])
        
        XCTAssertEqual(multiply(a, 2), Matrix([[2, 4, 6], [12, 10, 8]]))
        XCTAssertEqual(multiply(2, a), Matrix([[2, 4, 6], [12, 10, 8]]))
        
        let b = Matrix([[0, 1, 2], [3, 4, 5]])
        XCTAssertEqual(elementWiseProduct(a, b), Matrix([[0, 2, 6], [18, 20, 20]]))
    }
    
    func testDivide() {
        let a = Matrix([[1, 2, 3], [6, 5, 4]])
        
        XCTAssertEqual(divide(a, 2), Matrix([[0, 1, 1], [3, 2, 2]]))
        XCTAssertEqual(divide(2, a), Matrix([[2, 1, 0], [0, 0, 0]]))
        
        let b = Matrix([[1, 1, 2], [3, 4, 5]])
        XCTAssertEqual(divide(a, b), Matrix([[1, 2, 1], [2, 1, 0]]))
    }
    
    func testModulo() {
        let a = Matrix([[1, 2, 3], [6, 5, 4]])
        
        XCTAssertEqual(modulo(a, 2), Matrix([[1, 0, 1], [0, 1, 0]]))
        XCTAssertEqual(modulo(3, a), Matrix([[0, 1, 0], [3, 3, 3]]))
        
        let b = Matrix([[1, 1, 2], [3, 4, 5]])
        XCTAssertEqual(modulo(a, b), Matrix([[0, 0, 1], [0, 1, 4]]))
    }
    
    #if os(iOS) || os(OSX)
    
    func testUnaryMinusAccelerate() {
        let a = Matrix<Double>([[1, 2, 3], [6, 5, 4]])
        XCTAssertEqual(unaryMinusAccelerate(a), Matrix([[-1, -2, -3], [-6, -5, -4]]))
    }
    
    func testAddAccelerate() {
        
        let a = Matrix<Double>([[1, 2, 3], [6, 5, 4]])
    
        XCTAssertEqual(addAccelerate(a, 1), Matrix([[2, 3, 4], [7, 6, 5]]))
        
        let b = Matrix<Double>([[0, 1, 2], [3, 4, 5]])
        XCTAssertEqual(addAccelerate(a, b), Matrix([[1, 3, 5], [9, 9, 9]]))
    }
    
    func testSubtractAccelerate() {
        
        let a = Matrix<Double>([[1, 2, 3], [6, 5, 4]])
        let b = Matrix<Double>([[0, 1, 2], [3, 4, 5]])
        XCTAssertEqual(subtractAccelerate(a, b), Matrix([[1, 1, 1], [3, 1, -1]]))
    }
    
    func testElementWiseProductAccelerate() {
        
        let a = Matrix<Double>([[1, 2, 3], [6, 5, 4]])
        
        XCTAssertEqual(multiplyAccelerate(a, 2), Matrix([[2, 4, 6], [12, 10, 8]]))
        
        let b = Matrix<Double>([[0, 1, 2], [3, 4, 5]])
        XCTAssertEqual(elementWiseProductAccelerate(a, b), Matrix([[0, 2, 6], [18, 20, 20]]))
    }
    
    func testDivideAccelerate() {
        let a = Matrix<Double>([[1, 2, 3], [6, 5, 4]])
        
        XCTAssertEqual(divideAccelerate(a, 2), Matrix([[0.5, 1, 1.5], [3, 2.5, 2]]))
        XCTAssertEqual(divideAccelerate(3, a), Matrix([[3, 1.5, 1], [0.5, 0.6, 0.75]]))
        
        let b = Matrix<Double>([[1, 1, 2], [3, 4, 5]])
        XCTAssertEqual(divideAccelerate(a, b), Matrix([[1, 2, 1.5], [2, 1.25, 0.8]]))
    }

    #endif
    
    static var allTests: [(String, (MatrixArithmeticTests) -> () throws -> Void)] {
        return [
            ("testUnaryPlus", testUnaryPlus),
            ("testUnaryMinus", testUnaryMinus),
            ("testAdd", testAdd),
            ("testSubtract", testSubtract),
            ("testElementWiseProduct", testElementWiseProduct),
            ("testDivide", testDivide),
            ("testModulo", testModulo),
        ]
    }
    
}
