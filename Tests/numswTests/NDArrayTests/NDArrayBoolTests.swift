
import XCTest
@testable import numsw

class NDArrayBoolTests: XCTestCase {
    
    func testBool() {
        let a = NDArray(shape: [2, 2], elements: [true, false, true, false])
        let b = NDArray(shape: [2, 2], elements: [true, true, false, false])
        
        XCTAssertEqual(!a, NDArray(shape: [2, 2], elements: [false, true, false, true]))
        XCTAssertEqual(a && b, NDArray(shape: [2, 2], elements: [true, false, false, false]))
        XCTAssertEqual(a || b, NDArray(shape: [2, 2], elements: [true, true, true, false]))
    }
    
    func testCompare() {
        let a = NDArray(shape: [2, 2], elements: [1, 2, 3, 4])
        let b = NDArray(shape: [2, 2], elements: [1, 3, 2, 4])
        
        XCTAssertEqual(a == 2, NDArray(shape: [2, 2], elements: [false, true, false, false]))
        XCTAssertEqual(a < 2, NDArray(shape: [2, 2], elements: [true, false, false, false]))
        XCTAssertEqual(a > 3, NDArray(shape: [2, 2], elements: [false, false, false, true]))
        XCTAssertEqual(a <= 2, NDArray(shape: [2, 2], elements: [true, true, false, false]))
        XCTAssertEqual(a >= 3, NDArray(shape: [2, 2], elements: [false, false, true, true]))
        
        XCTAssertEqual(a == b, NDArray(shape: [2, 2], elements: [true, false, false, true]))
        XCTAssertEqual(a < b, NDArray(shape: [2, 2], elements: [false, true, false, false]))
        XCTAssertEqual(a > b, NDArray(shape: [2, 2], elements: [false, false, true, false]))
        XCTAssertEqual(a <= b, NDArray(shape: [2, 2], elements: [true, true, false, true]))
        XCTAssertEqual(a >= b, NDArray(shape: [2, 2], elements: [true, false, true, true]))
    }
}
