
import XCTest
@testable import numsw

class NDArrayBoolTests: XCTestCase {
    
    func testBool() {
        let a = NDArray(shape: [2, 2], elements: [true, false, true, false])
        let b = NDArray(shape: [2, 2], elements: [true, true, false, false])
        
        XCTAssertEqual(not(a), NDArray(shape: [2, 2], elements: [false, true, false, true]))
        XCTAssertEqual(and(a, b), NDArray(shape: [2, 2], elements: [true, false, false, false]))
        XCTAssertEqual(or(a, b), NDArray(shape: [2, 2], elements: [true, true, true, false]))
    }
    
    func testCompare() {
        let a = NDArray(shape: [2, 2], elements: [1, 2, 3, 4])
        let b = NDArray(shape: [2, 2], elements: [1, 3, 2, 4])
        
        XCTAssertEqual(equal(a, 2), NDArray(shape: [2, 2], elements: [false, true, false, false]))
        XCTAssertEqual(lessThan(a, 2), NDArray(shape: [2, 2], elements: [true, false, false, false]))
        XCTAssertEqual(greaterThan(a, 3), NDArray(shape: [2, 2], elements: [false, false, false, true]))
        XCTAssertEqual(notGreaterThan(a, 2), NDArray(shape: [2, 2], elements: [true, true, false, false]))
        XCTAssertEqual(notLessThan(a, 3), NDArray(shape: [2, 2], elements: [false, false, true, true]))
        
        XCTAssertEqual(equal(a, b), NDArray(shape: [2, 2], elements: [true, false, false, true]))
        XCTAssertEqual(lessThan(a, b), NDArray(shape: [2, 2], elements: [false, true, false, false]))
        XCTAssertEqual(greaterThan(a, b), NDArray(shape: [2, 2], elements: [false, false, true, false]))
        XCTAssertEqual(notGreaterThan(a, b), NDArray(shape: [2, 2], elements: [true, true, false, true]))
        XCTAssertEqual(notLessThan(a, b), NDArray(shape: [2, 2], elements: [true, false, true, true]))
    }
    
    static var allTests: [(String, (NDArrayBoolTests) -> () throws -> Void)] {
        return [
            ("testBool", testBool),
            ("testCompare", testCompare),
        ]
    }
}
