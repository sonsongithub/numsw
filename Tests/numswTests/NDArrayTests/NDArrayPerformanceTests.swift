
import XCTest
@testable import numsw

class NDArrayPerformanceTests: XCTestCase {
    
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
}
