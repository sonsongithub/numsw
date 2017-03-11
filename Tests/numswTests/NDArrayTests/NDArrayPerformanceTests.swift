
import XCTest
@testable import numsw

class NDArrayPerformanceTests: XCTestCase {
    
    func testTransposePerformance() {
        let a = NDArray<Int>.zeros([10, 10, 10, 10])
        measure {
            a.transposed()
        }
    }
    
    func testSubscriptSubarrayPerformance() {
        let a = NDArray<Int>.zeros([1000, 1000])
        measure {
            a[0..<300, 100..<200]
        }
    }
    
    func testStackPerformance0() {
        let a = NDArray<Int>.zeros([1000, 1000])
        measure {
            NDArray.concatenate([a, a, a], along: 0)
        }
    }
    
    func testStackPerformance1() {
        let a = NDArray<Int>.zeros([1000, 1000])
        measure {
            NDArray.concatenate([a, a, a], along: 1)
        }
    }
    
    func testDividePerformance() {
        let a = NDArray<Double>.linspace(low: 1, high: 1e7, count: 100000)
        let b = NDArray<Double>.linspace(low: 10, high: 1e7, count: 100000)
        measure {
            divide(a, b)
        }
    }
    
    #if os(iOS) || os(OSX)
    func testDivideAcceleratePerformance() {
        let a = NDArray<Double>.linspace(low: 1, high: 1e7, count: 100000)
        let b = NDArray<Double>.linspace(low: 10, high: 1e7, count: 100000)
        measure {
            divideAccelerate(a, b)
        }
    }
    #endif
    
    func testSqrtPerformance() {
        let a = NDArray<Double>.linspace(low: -10*M_PI, high: 10*M_PI, count: 1000000)
        measure {
            _sqrt(a)
        }
    }
    
    #if os(iOS) || os(OSX)
    func testSqrtAcceleratePerformance() {
        let a = NDArray<Double>.linspace(low: -10*M_PI, high: 10*M_PI, count: 1000000)
        measure {
            _sqrtAccelerate(a)
        }
    }
    #endif
    
    func testSumPerformance() {
        let a = NDArray<Double>.linspace(low: 0, high: 1e4, count: 100000)
        measure {
            _sum(a)
        }
    }
    
    func testSumPerformance2() {
        let a = NDArray<Double>.linspace(low: 0, high: 1e4, count: 100000).reshaped([10, 10, 10, 10, 10])
        measure {
            _sum(a, along: 2)
        }
    }
    
    #if os(iOS) || os(OSX)
    func testSumAcceleratePerformance() {
        let a = NDArray<Double>.linspace(low: 0, high: 1e4, count: 100000)
        measure {
            _sumAccelerate(a)
        }
    }
    
    func testSumAcceleratePerformance2() {
        let a = NDArray<Double>.linspace(low: 0, high: 1e4, count: 100000).reshaped([10, 10, 10, 10, 10])
        measure {
            _sumAccelerate(a, along: 2)
        }
    }
    #endif
    
    func testNormalPerformance() {
        measure {
            NDArray<Double>.normal(mu: 0, sigma: 1, shape: [100, 100])
        }
    }
}
