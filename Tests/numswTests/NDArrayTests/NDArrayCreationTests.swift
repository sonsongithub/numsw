

import XCTest
@testable import numsw

class NDArrayCreationTests: XCTestCase {
    
    func testZeros() {
        XCTAssertEqual(NDArray<Int>.zeros([3, 4]),
                       NDArray(shape: [3, 4], elements: [Int](repeating: 0, count: 12)))
        
        XCTAssertEqual(NDArray<Float>.zeros([2, 5]),
                       NDArray(shape: [2, 5], elements: [Float](repeating: 0, count: 10)))
    }
    
    func testOnes() {
        XCTAssertEqual(NDArray<Int>.ones([3, 4]),
                       NDArray(shape: [3, 4], elements: [Int](repeating: 1, count: 12)))
        
        XCTAssertEqual(NDArray<Float>.ones([2, 5]),
                       NDArray(shape: [2, 5], elements: [Float](repeating: 1, count: 10)))
    }
    
    func testEye() {
        XCTAssertEqual(NDArray<Int>.eye(3),
                       NDArray(shape: [3, 3], elements: [1, 0, 0,
                                                         0, 1, 0,
                                                         0, 0, 1]))
        XCTAssertEqual(NDArray<Double>.eye(2),
                       NDArray(shape: [2, 2], elements: [1.0, 0.0,
                                                         0.0, 1.0]))
    }
    
    func testRange() {
        XCTAssertEqual(NDArray<Int>.range(from: 0, to: 5, stride: 1),
                       NDArray(shape: [5], elements: [0, 1, 2, 3, 4]))
        
        XCTAssertEqualWithAccuracy(NDArray<Double>.range(from: -1, to: 5, stride: 1),
                                   NDArray<Double>(shape: [6], elements: [-1, 0, 1, 2, 3, 4]),
                                   accuracy: 1e-10)
        
        XCTAssertEqualWithAccuracy(NDArray<Double>.range(from: -1, to: 2, stride: 0.5),
                                   NDArray<Double>(shape: [6], elements: [-1, -0.5, 0, 0.5, 1, 1.5]),
                                   accuracy: 1e-10)
    }
    
    func testLinspace() {
        XCTAssertEqualWithAccuracy(NDArray<Float>.linspace(low: 0.1, high: 0.5, count: 9),
                                   NDArray<Float>(shape: [9],
                                                  elements: [0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5]),
                                   accuracy: 1e-10)
        
        XCTAssertEqualWithAccuracy(NDArray<Double>.linspace(low: 0.1, high: 1, count: 10),
                                   NDArray<Double>(shape: [10],
                                                   elements: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]),
                                   accuracy: 1e-10)
    }
}
