import XCTest
import numsw

func XCTAssertEqual<T: Equatable>(_ expression1: Matrix<T>, _ expression2: Matrix<T>) {
    XCTAssertEqual(expression1.rows, expression2.rows)
    XCTAssertEqual(expression1.columns, expression2.columns)
    XCTAssertEqual(expression1.elements, expression2.elements)
}

func XCTAssertEqualWithAccuracy<T: BinaryFloatingPoint>(_ expression1: Matrix<T>, _ expression2: Matrix<T>, accuracy: T = 1e-5) {
    
    XCTAssertEqual(expression1.rows, expression2.rows)
    XCTAssertEqual(expression1.columns, expression2.columns)
    
    for (a, b) in zip(expression1.elements, expression2.elements) {
        XCTAssertEqualWithAccuracy(a, b, accuracy: accuracy)
    }
}
