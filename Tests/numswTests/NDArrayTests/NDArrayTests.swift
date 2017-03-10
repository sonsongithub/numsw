
import XCTest
@testable import numsw

class NDArrayTests: XCTestCase {
    
    func testReshape() {
        let elements = [Int](0..<12)
        let a = NDArray(shape: [3, 4], elements: elements)
        
        XCTAssertEqual(a.reshaped([6, 2]), NDArray(shape: [6, 2], elements: elements))
        XCTAssertEqual(a.reshaped([3, 2, 2]), NDArray(shape: [3, 2, 2], elements: elements))
        
        // minus
        XCTAssertEqual(a.reshaped([-1, 2]), NDArray(shape: [6, 2], elements: elements))
        XCTAssertEqual(a.reshaped([6, -1]), NDArray(shape: [6, 2], elements: elements))
        XCTAssertEqual(a.reshaped([-1, 2, 2]), NDArray(shape: [3, 2, 2], elements: elements))
        
        
        var b = NDArray(shape: [3, 4], elements: elements)
        b.shape = [-1, 1]
        XCTAssertEqual(b, NDArray(shape: [12,1], elements: elements))
        b.shape = [-1]
        XCTAssertEqual(b, NDArray(shape: [12], elements: elements))
    }
    
    func testRavel() {
        let elements = [Int](0..<12)
        let a = NDArray(shape: [3, 4], elements: elements)
        
        XCTAssertEqual(a.raveled(), NDArray(shape: [12], elements: elements))
    }
    
}
