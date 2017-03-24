import Foundation
import XCTest
@testable import numsw

class NDArrayPerformanceTests: XCTestCase {
    
    func testTransposePerformance() {
        let a = NDArray<Int>.zeros([10, 10, 10, 10])
        measure {
            _ = a.transposed()
        }
    }
    
    func testSubscriptSubarrayPerformance() {
        let a = NDArray<Int>.zeros([1000, 1000])
        measure {
            _ = a[0..<300, 100..<200]
        }
    }
    
    func testStackPerformance0() {
        let a = NDArray<Int>.zeros([1000, 1000])
        measure {
            _ = NDArray.concatenate([a, a, a], along: 0)
        }
    }
    
    func testStackPerformance1() {
        let a = NDArray<Int>.zeros([1000, 1000])
        measure {
            _ = NDArray.concatenate([a, a, a], along: 1)
        }
    }
    
    func testDividePerformance() {
        let a = NDArray<Double>.linspace(low: 1, high: 1e7, count: 100000)
        let b = NDArray<Double>.linspace(low: 10, high: 1e7, count: 100000)
        measure {
            _ = divide(a, b)
        }
    }
    
    #if os(iOS) || os(OSX)
    func testDivideAcceleratePerformance() {
        let a = NDArray<Double>.linspace(low: 1, high: 1e7, count: 100000)
        let b = NDArray<Double>.linspace(low: 10, high: 1e7, count: 100000)
        measure {
            _ = divideAccelerate(a, b)
        }
    }
    #endif
    
    func testSqrtPerformance() {
        let a = NDArray<Double>.linspace(low: -10*M_PI, high: 10*M_PI, count: 1000000)
        measure {
            _ = _sqrt(a)
        }
    }
    
    #if os(iOS) || os(OSX)
    func testSqrtAcceleratePerformance() {
        let a = NDArray<Double>.linspace(low: -10*M_PI, high: 10*M_PI, count: 1000000)
        measure {
            _ = _sqrtAccelerate(a)
        }
    }
    #endif
    
    func testSumPerformance0() {
        let a = NDArray<Double>.linspace(low: 0, high: 1e4, count: 100000)
        measure {
            _ = _sum(a)
        }
    }
    
    func testSumPerformance1() {
        let a = NDArray<Double>.linspace(low: 0, high: 1e4, count: 100000).reshaped([10, 10, 10, 10, 10])
        measure {
            _ = _sum(a, along: 2)
        }
    }
    
    #if os(iOS) || os(OSX)
    func testSumAcceleratePerformance() {
        let a = NDArray<Double>.linspace(low: 0, high: 1e4, count: 100000)
        measure {
            _ = _sumAccelerate(a)
        }
    }
    
    func testSumAcceleratePerformance2() {
        let a = NDArray<Double>.linspace(low: 0, high: 1e4, count: 100000).reshaped([10, 10, 10, 10, 10])
        measure {
            _ = _sumAccelerate(a, along: 2)
        }
    }
    #endif
    
    func testNormalPerformance() {
        measure {
            _ = NDArray<Double>.normal(mu: 0, sigma: 1, shape: [100, 100])
        }
    }
    
    static var allTests: [(String, (NDArrayPerformanceTests) -> () throws -> Void)] {
        return [
            ("testTransposePerformance", testTransposePerformance),
            ("testSubscriptSubarrayPerformance", testSubscriptSubarrayPerformance),
            ("testStackPerformance0", testStackPerformance0),
            ("testStackPerformance1", testStackPerformance1),
            ("testDividePerformance", testDividePerformance),
            ("testSqrtPerformance", testSqrtPerformance),
            ("testSumPerformance0", testSumPerformance0),
            ("testSumPerformance1", testSumPerformance1),
            ("testNormalPerformance", testNormalPerformance)
        ]
    }
}
