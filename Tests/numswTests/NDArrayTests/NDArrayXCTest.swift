import XCTest
import numsw

func XCTAssertEqual<T: Equatable>(_ expression1: NDArray<T>, _ expression2: NDArray<T>) {
    XCTAssertEqual(expression1.shape, expression2.shape)
    XCTAssertEqual(expression1.elements, expression2.elements)
}

func XCTAssertEqualWithAccuracy<T: BinaryFloatingPoint>(_ expression1: NDArray<T>,
                                _ expression2: NDArray<T>,
                                accuracy: T = 1e-5) {
    
    XCTAssertEqual(expression1.shape, expression2.shape)
    
    for (a, b) in zip(expression1.elements, expression2.elements) {
        XCTAssertEqualWithAccuracy(a, b, accuracy: accuracy)
    }
}
