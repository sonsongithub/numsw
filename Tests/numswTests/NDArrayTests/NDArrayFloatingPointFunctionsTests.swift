
import XCTest
@testable import numsw

class NDArrayFloatingPointFunctionsTests: XCTestCase {
    
    func testExp() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(exp(a), NDArray(shape: [2, 2], elements: elements.map(exp)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(exp(a), NDArray(shape: [2, 2], elements: elements.map(exp)))
        }
    }
    
    func testLog() {
        do {
            let elements: [Float] = [0.1, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(log(a), NDArray(shape: [2, 2], elements: elements.map(log)))
        }
        do {
            let elements: [Double] = [0.1, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(log(a), NDArray(shape: [2, 2], elements: elements.map(log)))
        }
    }
    
    func testSin() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(sin(a), NDArray(shape: [2, 2], elements: elements.map(sin)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(sin(a), NDArray(shape: [2, 2], elements: elements.map(sin)))
        }
    }
    
    func testCos() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(cos(a), NDArray(shape: [2, 2], elements: elements.map(cos)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(cos(a), NDArray(shape: [2, 2], elements: elements.map(cos)))
        }
    }
    
    func testTan() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(tan(a), NDArray(shape: [2, 2], elements: elements.map(tan)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(tan(a), NDArray(shape: [2, 2], elements: elements.map(tan)))
        }
    }
    
}
