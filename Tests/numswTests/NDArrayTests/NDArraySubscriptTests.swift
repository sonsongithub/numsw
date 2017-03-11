
import XCTest
@testable import numsw

class NDArraySubscriptTests: XCTestCase {
    
    func testSubscriptGetElement() {
        let x = NDArray<Int>(shape: [3, 2], elements: [1, 2, 3, 4, 5, 6])
        
        // normal access
        XCTAssertEqual(x[0, 0], 1)
        XCTAssertEqual(x[0, 1], 2)
        XCTAssertEqual(x[1, 0], 3)
        XCTAssertEqual(x[1, 1], 4)
        XCTAssertEqual(x[2, 0], 5)
        XCTAssertEqual(x[2, 1], 6)
        
        // minus index access
        XCTAssertEqual(x[-3, -2], 1)
        XCTAssertEqual(x[-3, -1], 2)
        XCTAssertEqual(x[-2, -2], 3)
        XCTAssertEqual(x[-2, -1], 4)
        XCTAssertEqual(x[-1, -2], 5)
        XCTAssertEqual(x[-1, -1], 6)
    }
    
    func testSubscriptSetElement() {
        var x = NDArray<Int>(shape: [3, 2], elements: [1, 2, 3, 4, 5, 6])
        
        x[0, 0] = -1
        XCTAssertEqual(x, NDArray<Int>(shape: [3, 2], elements: [-1, 2, 3, 4, 5, 6]))
        
        x[-1, -1] = -2
        XCTAssertEqual(x, NDArray<Int>(shape: [3, 2], elements: [-1, 2, 3, 4, 5, -2]))
    }
    
    func testSubscriptGetSubarray() {
        let x = NDArray<Int>(shape: [3, 2], elements: [1, 2, 3, 4, 5, 6])
        
        // get subarray
        XCTAssertEqual(x[[0, 1], [0, 1]], NDArray(shape: [2, 2], elements: [1, 2, 3, 4]))
        XCTAssertEqual(x[0..<2, 0..<2], NDArray(shape: [2, 2], elements: [1, 2, 3, 4]))
        
        // auto fulfill
        XCTAssertEqual(x[[0]], NDArray(shape: [1, 2], elements: [1, 2]))
        XCTAssertEqual(x[[-3]], NDArray(shape: [1, 2], elements: [1, 2]))
        XCTAssertEqual(x[0..<1], NDArray(shape: [1, 2], elements: [1, 2]))
        XCTAssertEqual(x[(-3)..<(-2)], NDArray(shape: [1, 2], elements: [1, 2]))
        
        // nil means numpy's `:`
        XCTAssertEqual(x[nil, [0]], NDArray(shape: [3, 1], elements: [1, 3, 5]))
    }
    
    func testSubscriptSetSubarray() {
        var x = NDArray<Int>(shape: [3, 2], elements: [1, 2, 3, 4, 5, 6])
        x[[-3]] = NDArray(shape: [1, 2], elements: [0, 0])
        XCTAssertEqual(x, NDArray<Int>(shape: [3, 2], elements: [0, 0, 3, 4, 5, 6]))
        x[nil, [0]] = NDArray(shape: [3, 1], elements: [0, 0, 0])
        XCTAssertEqual(x, NDArray(shape: [3, 2], elements: [0, 0, 0, 4, 0, 6]))
    }
    
    static var allTests: [(String, (NDArraySubscriptTests) -> () throws -> Void)] {
        return [
            ("testSubscriptGetElement", testSubscriptGetElement),
            ("testSubscriptSetElement", testSubscriptSetElement),
            ("testSubscriptGetSubarray", testSubscriptGetSubarray),
            ("testSubscriptSetSubarray", testSubscriptSetSubarray),
        ]
    }
}
