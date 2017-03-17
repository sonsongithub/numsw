
import Foundation
import XCTest
@testable import numsw

class NDArrayFloatingPointFunctionsTests: XCTestCase {
    
    func testSqrt() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sqrt(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sqrt)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sqrt(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sqrt)))
        }
    }
    
    func testExp() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_exp(a),
                                       NDArray(shape: [2, 2], elements: elements.map(exp)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_exp(a),
                                       NDArray(shape: [2, 2], elements: elements.map(exp)))
        }
    }
    
    func testLog() {
        do {
            let elements: [Float] = [0.1, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_log(a),
                                       NDArray(shape: [2, 2], elements: elements.map(log)))
        }
        do {
            let elements: [Double] = [0.1, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_log(a),
                                       NDArray(shape: [2, 2], elements: elements.map(log)))
        }
    }
    
    func testSin() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sin(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sin)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sin(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sin)))
        }
    }
    
    func testCos() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_cos(a),
                                       NDArray(shape: [2, 2], elements: elements.map(cos)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_cos(a),
                                       NDArray(shape: [2, 2], elements: elements.map(cos)))
        }
    }
    
    func testTan() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_tan(a),
                                       NDArray(shape: [2, 2], elements: elements.map(tan)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_tan(a),
                                       NDArray(shape: [2, 2], elements: elements.map(tan)))
        }
    }
    
    #if os(iOS) || os(OSX)
    
    func testSqrtAccelerate() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sqrtAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sqrt)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sqrtAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sqrt)))
        }
    }
    
    func testExpAccelerate() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_expAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(exp)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_expAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(exp)))
        }
    }
    
    func testLogAccelerate() {
        do {
            let elements: [Float] = [0.1, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_logAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(log)))
        }
        do {
            let elements: [Double] = [0.1, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_logAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(log)))
        }
    }
    
    func testSinAccelerate() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sinAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sin)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sinAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sin)))
        }
    }
    
    func testCosAccelerate() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_cosAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(cos)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_cosAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(cos)))
        }
    }
    
    func testTanAccelerate() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_tanAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(tan)))
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_tanAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(tan)))
        }
    }

    #endif
    
    static var allTests: [(String, (NDArrayFloatingPointFunctionsTests) -> () throws -> Void)] {
        return [
            ("testSqrt", testSqrt),
            ("testExp", testExp),
            ("testLog", testLog),
            ("testSin", testSin),
            ("testCos", testCos),
            ("testTan", testTan),
        ]
    }
    
}
