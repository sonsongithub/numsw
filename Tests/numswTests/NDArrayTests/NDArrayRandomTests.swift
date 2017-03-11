
import XCTest
@testable import numsw

class NDArrayRandomTests: XCTestCase {
    
    func testUnifrom() {
        let a = NDArray<Double>.uniform(low: -1, high: 1, shape: [100000])
        for e in a.elements {
            XCTAssert(-1 <= e && e < 1)
        }
    }
}
