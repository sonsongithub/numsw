
import XCTest
@testable import numsw

class NDArrayArithmeticTests: XCTestCase {
    
    
    func testUnaryPlus() {
        do {
            let a = NDArray<Int>(shape: [2, 2], elements: [1, 2, 3, 4])
            XCTAssertEqual(+a, a)
        }
        do {
            let a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            XCTAssertEqual(+a, a)
        }
    }
    
    func testUnaryMinus() {
        do {
            let a = NDArray<Int>(shape: [2, 2], elements: [1, 2, 3, 4])
            XCTAssertEqual(-a, NDArray(shape: [2, 2], elements: [-1, -2, -3, -4]))
        }
        do {
            let a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            XCTAssertEqual(-a, NDArray(shape: [2, 2], elements: [-1, -2, -3, -4]))
        }
    }
    
    func testPlus() {
        // NDArray and scalar
        do {
            let a = NDArray<Int>(shape: [2, 2], elements: [1, 2, 3, 4])
            XCTAssertEqual(a + 1, NDArray(shape: [2, 2], elements: [2, 3, 4, 5]))
            XCTAssertEqual(1 + a, NDArray(shape: [2, 2], elements: [2, 3, 4, 5]))
        }
        do {
            let a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            XCTAssertEqual(a + 1, NDArray(shape: [2, 2], elements: [2, 3, 4, 5]))
            XCTAssertEqual(1 + a, NDArray(shape: [2, 2], elements: [2, 3, 4, 5]))
        }
        
        // NDArray and NDArray
        do {
            let a = NDArray<Int>(shape: [2, 2], elements: [1, 2, 3, 4])
            let b = NDArray<Int>(shape: [2, 2], elements: [-1, 0, 1, 0])
            XCTAssertEqual(a + b, NDArray(shape: [2, 2], elements: [0, 2, 4, 4]))
        }
        do {
            let a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            let b = NDArray<Double>(shape: [2, 2], elements: [-1, 0, 1, 0])
            XCTAssertEqual(a + b, NDArray(shape: [2, 2], elements: [0, 2, 4, 4]))
        }
    }
    
    func testMinus() {
        // NDArray and scalar
        do {
            let a = NDArray<Int>(shape: [2, 2], elements: [1, 2, 3, 4])
            XCTAssertEqual(a - 1, NDArray(shape: [2, 2], elements: [0, 1, 2, 3]))
            XCTAssertEqual(1 - a, NDArray(shape: [2, 2], elements: [0, -1, -2, -3]))
        }
        do {
            let a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            XCTAssertEqual(a - 1, NDArray(shape: [2, 2], elements: [0, 1, 2, 3]))
            XCTAssertEqual(1 - a, NDArray(shape: [2, 2], elements: [0, -1, -2, -3]))
        }
        
        // NDArray and NDArray
        do {
            let a = NDArray<Int>(shape: [2, 2], elements: [1, 2, 3, 4])
            let b = NDArray<Int>(shape: [2, 2], elements: [-1, 0, 1, 0])
            XCTAssertEqual(a - b, NDArray(shape: [2, 2], elements: [2, 2, 2, 4]))
        }
        do {
            let a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            let b = NDArray<Double>(shape: [2, 2], elements: [-1, 0, 1, 0])
            XCTAssertEqual(a - b, NDArray(shape: [2, 2], elements: [2, 2, 2, 4]))
        }
    }
    
    func testMultiply() {
        // NDArray and scalar
        do {
            let a = NDArray<Int>(shape: [2, 2], elements: [1, 2, 3, 4])
            XCTAssertEqual(a * 2, NDArray(shape: [2, 2], elements: [2, 4, 6, 8]))
            XCTAssertEqual(2 * a, NDArray(shape: [2, 2], elements: [2, 4, 6, 8]))
        }
        do {
            let a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            XCTAssertEqual(a * 2, NDArray(shape: [2, 2], elements: [2, 4, 6, 8]))
            XCTAssertEqual(2 * a, NDArray(shape: [2, 2], elements: [2, 4, 6, 8]))
        }
        
        // NDArray and NDArray
        do {
            let a = NDArray<Int>(shape: [2, 2], elements: [1, 2, 3, 4])
            let b = NDArray<Int>(shape: [2, 2], elements: [-1, 0, 2, 1])
            XCTAssertEqual(a * b, NDArray(shape: [2, 2], elements: [-1, 0, 6, 4]))
        }
        do {
            let a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            let b = NDArray<Double>(shape: [2, 2], elements: [-1, 0, 2, 1])
            XCTAssertEqual(a * b, NDArray(shape: [2, 2], elements: [-1, 0, 6, 4]))
        }
    }
    
    func testDivide() {
        // NDArray and scalar
        do {
            let a = NDArray<Int>(shape: [2, 2], elements: [1, 2, 3, 4])
            XCTAssertEqual(a / 2, NDArray(shape: [2, 2], elements: [0, 1, 1, 2]))
            XCTAssertEqual(2 / a, NDArray(shape: [2, 2], elements: [2, 1, 0, 0]))
        }
        do {
            let a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            XCTAssertEqual(a / 2, NDArray(shape: [2, 2], elements: [0.5, 1.0, 1.5, 2.0]))
            XCTAssertEqualWithAccuracy(2 / a, NDArray(shape: [2, 2], elements: [2.0, 1.0, 2.0/3.0, 0.5]),
                                       accuracy: 1e-10)
        }
        
        // NDArray and NDArray
        do {
            let a = NDArray<Int>(shape: [2, 2], elements: [1, 2, 3, 4])
            let b = NDArray<Int>(shape: [2, 2], elements: [-1, 2, 6, 1])
            XCTAssertEqual(a / b, NDArray(shape: [2, 2], elements: [-1, 1, 0, 4]))
        }
        do {
            let a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            let b = NDArray<Double>(shape: [2, 2], elements: [-1, 2, 6, 1])
            XCTAssertEqual(a / b, NDArray(shape: [2, 2], elements: [-1, 1, 0.5, 4]))
        }
    }
    
    func testModulo() {
        // NDArray and scalar
        do {
            let a = NDArray<Int>(shape: [2, 2], elements: [1, 2, 3, 4])
            XCTAssertEqual(a % 2, NDArray(shape: [2, 2], elements: [1, 0, 1, 0]))
            XCTAssertEqual(2 % a, NDArray(shape: [2, 2], elements: [0, 0, 2, 2]))
        }
        
        // NDArray and NDArray
        do {
            let a = NDArray<Int>(shape: [2, 2], elements: [1, 2, 3, 4])
            let b = NDArray<Int>(shape: [2, 2], elements: [3, 2, 2, 3])
            XCTAssertEqual(a % b, NDArray(shape: [2, 2], elements: [1, 0, 1, 1]))
        }
    }
    
}
