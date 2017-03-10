
import XCTest
@testable import numsw

class NDArrayFloatingPointFunctionsTests: XCTestCase {
    
    let accuracyf: Float = 1e-5
    let accuracy: Double = 1e-5
    
    func testSqrt() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sqrt(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sqrt)),
                                       accuracy: accuracyf)
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sqrt(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sqrt)),
                                       accuracy: accuracy)
        }
    }
    
    func testExp() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_exp(a),
                                       NDArray(shape: [2, 2], elements: elements.map(exp)),
                                       accuracy: accuracyf)
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_exp(a),
                                       NDArray(shape: [2, 2], elements: elements.map(exp)),
                                       accuracy: accuracy)
        }
    }
    
    func testLog() {
        do {
            let elements: [Float] = [0.1, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_log(a),
                                       NDArray(shape: [2, 2], elements: elements.map(log)),
                                       accuracy: accuracyf)
        }
        do {
            let elements: [Double] = [0.1, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_log(a),
                                       NDArray(shape: [2, 2], elements: elements.map(log)),
                                       accuracy: accuracy)
        }
    }
    
    func testSin() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sin(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sin)),
                                       accuracy: accuracyf)
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sin(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sin)),
                                       accuracy: accuracy)
        }
    }
    
    func testCos() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_cos(a),
                                       NDArray(shape: [2, 2], elements: elements.map(cos)),
                                       accuracy: accuracyf)
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_cos(a),
                                       NDArray(shape: [2, 2], elements: elements.map(cos)),
                                       accuracy: accuracy)
        }
    }
    
    func testTan() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_tan(a),
                                       NDArray(shape: [2, 2], elements: elements.map(tan)),
                                       accuracy: accuracyf)
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_tan(a),
                                       NDArray(shape: [2, 2], elements: elements.map(tan)),
                                       accuracy: accuracy)
        }
    }
    
    #if os(iOS) || os(OSX)
    
    func testSqrtAccelerate() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sqrtAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sqrt)),
                                       accuracy: accuracyf)
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sqrtAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sqrt)),
                                       accuracy: accuracy)
        }
    }
    
    func testExpAccelerate() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_expAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(exp)),
                                       accuracy: accuracyf)
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_expAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(exp)),
                                       accuracy: accuracy)
        }
    }
    
    func testLogAccelerate() {
        do {
            let elements: [Float] = [0.1, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_logAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(log)),
                                       accuracy: accuracyf)
        }
        do {
            let elements: [Double] = [0.1, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_logAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(log)),
                                       accuracy: accuracy)
        }
    }
    
    func testSinAccelerate() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sinAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sin)),
                                       accuracy: accuracyf)
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_sinAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(sin)),
                                       accuracy: accuracy)
        }
    }
    
    func testCosAccelerate() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_cosAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(cos)),
                                       accuracy: accuracyf)
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_cosAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(cos)),
                                       accuracy: accuracy)
        }
    }
    
    func testTanAccelerate() {
        do {
            let elements: [Float] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_tanAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(tan)),
                                       accuracy: accuracyf)
        }
        do {
            let elements: [Double] = [0, 0.5, 1, 1.5]
            let a = NDArray(shape: [2, 2], elements: elements)
            XCTAssertEqualWithAccuracy(_tanAccelerate(a),
                                       NDArray(shape: [2, 2], elements: elements.map(tan)),
                                       accuracy: accuracy)
        }
    }

    #endif
    
}
