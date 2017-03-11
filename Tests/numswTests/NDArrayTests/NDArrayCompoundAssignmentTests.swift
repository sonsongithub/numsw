
import XCTest
@testable import numsw

class NDArrayCompoundAssignmentTests: XCTestCase {
    
    func testAddAssign() {
        // scalar
        do {
            var a = NDArray(shape: [2, 2], elements: [1, 2, 3, 4])
            a += 2
            XCTAssertEqual(a, NDArray(shape: [2, 2], elements: [3, 4, 5, 6]))
        }
        do {
            var a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            a += 2
            XCTAssertEqual(a, NDArray(shape: [2, 2], elements: [3, 4, 5, 6]))
        }
        // NDArray
        do {
            var a = NDArray(shape: [2, 2], elements: [1, 2, 3, 4])
            let b = NDArray(shape: [2, 2], elements: [1, -2, 6, 0])
            a += b
            XCTAssertEqual(a, NDArray(shape: [2, 2], elements: [2, 0, 9, 4]))
        }
        do {
            var a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            let b = NDArray<Double>(shape: [2, 2], elements: [1, -2, 6, 0])
            a += b
            XCTAssertEqual(a, NDArray(shape: [2, 2], elements: [2, 0, 9, 4]))
        }
    }
    
    func testSubtractAssign() {
        // scalar
        do {
            var a = NDArray(shape: [2, 2], elements: [1, 2, 3, 4])
            a -= 2
            XCTAssertEqual(a, NDArray(shape: [2, 2], elements: [-1, 0, 1, 2]))
        }
        do {
            var a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            a -= 2
            XCTAssertEqual(a, NDArray(shape: [2, 2], elements: [-1, 0, 1, 2]))
        }
        // NDArray
        do {
            var a = NDArray(shape: [2, 2], elements: [1, 2, 3, 4])
            let b = NDArray(shape: [2, 2], elements: [1, -2, 6, 0])
            a -= b
            XCTAssertEqual(a, NDArray(shape: [2, 2], elements: [0, 4, -3, 4]))
        }
        do {
            var a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            let b = NDArray<Double>(shape: [2, 2], elements: [1, -2, 6, 0])
            a -= b
            XCTAssertEqual(a, NDArray(shape: [2, 2], elements: [0, 4, -3, 4]))
        }
    }
    
    func testMultiplyAssign() {
        // scalar
        do {
            var a = NDArray(shape: [2, 2], elements: [1, 2, 3, 4])
            a *= 2
            XCTAssertEqual(a, NDArray(shape: [2, 2], elements: [2, 4, 6, 8]))
        }
        do {
            var a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            a *= 2
            XCTAssertEqual(a, NDArray(shape: [2, 2], elements: [2, 4, 6, 8]))
        }
        // NDArray
        do {
            var a = NDArray(shape: [2, 2], elements: [1, 2, 3, 4])
            let b = NDArray(shape: [2, 2], elements: [1, -2, 6, 0])
            a *= b
            XCTAssertEqual(a, NDArray(shape: [2, 2], elements: [1, -4, 18, 0]))
        }
        do {
            var a = NDArray<Double>(shape: [2, 2], elements: [1, 2, 3, 4])
            let b = NDArray<Double>(shape: [2, 2], elements: [1, -2, 6, 0])
            a *= b
            XCTAssertEqual(a, NDArray(shape: [2, 2], elements: [1, -4, 18, 0]))
        }
    }
    
    static var allTests: [(String, (NDArrayCompoundAssignmentTests) -> () throws -> Void)] {
        return [
            ("testAddAssign", testAddAssign),
            ("testSubtractAssign", testSubtractAssign),
            ("testMultiplyAssign", testMultiplyAssign),
        ]
    }
    
}
