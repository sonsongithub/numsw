import XCTest
@testable import numsw

class NDArrayRandomTests: XCTestCase {
    
    func testUniform() {
        let a = NDArray<Double>.uniform(low: -1, high: 1, shape: [100000])
        for e in a.elements {
            XCTAssert(-1 <= e && e < 1)
        }
    }
    
    func testNormal() {
        let a = NDArray<Double>.normal(mu: 0, sigma: 1, shape: [1000])
        print(a.elements)
    }
    
    static var allTests: [(String, (NDArrayRandomTests) -> () throws -> Void)] {
        return [
            ("testUniform", testUniform)
        ]
    }
}
