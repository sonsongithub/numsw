
import XCTest
@testable import numsw

class NDArrayFloatingPointFunctionsTests: XCTestCase {
    
    func testSqrt() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(_sqrt(a), NDArray(shape: [2, 2], elements: elements.map(sqrt)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(_sqrt(a), NDArray(shape: [2, 2], elements: elements.map(sqrt)))
        }
    }
    
    func testExp() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(_exp(a), NDArray(shape: [2, 2], elements: elements.map(exp)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(_exp(a), NDArray(shape: [2, 2], elements: elements.map(exp)))
        }
    }
    
    func testLog() {
        do {
            let elements: [Float] = [0.1, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(_log(a), NDArray(shape: [2, 2], elements: elements.map(log)))
        }
        do {
            let elements: [Double] = [0.1, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(_log(a), NDArray(shape: [2, 2], elements: elements.map(log)))
        }
    }
    
    func testSin() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(_sin(a), NDArray(shape: [2, 2], elements: elements.map(sin)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(_sin(a), NDArray(shape: [2, 2], elements: elements.map(sin)))
        }
    }
    
    func testCos() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(_cos(a), NDArray(shape: [2, 2], elements: elements.map(cos)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(_cos(a), NDArray(shape: [2, 2], elements: elements.map(cos)))
        }
    }
    
    func testTan() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(_tan(a), NDArray(shape: [2, 2], elements: elements.map(tan)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqual(_tan(a), NDArray(shape: [2, 2], elements: elements.map(tan)))
        }
    }
    
}
