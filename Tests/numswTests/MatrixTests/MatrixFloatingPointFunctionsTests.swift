import XCTest
@testable import numsw

class MatrixFloatingPointFunctionsTests: XCTestCase {
    
    func testExp() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = _exp(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [7.3891, 2.7183, 1.2214, 1.1052])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    func testLog() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = _log(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [0.6931, 0, -1.6094, -2.3026])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    func testCos() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = _cos(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [-0.4161, 0.5403, 0.9801, 0.9950])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    func testSin() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = _sin(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [0.9093, 0.8415, 0.1987, 0.0998])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    func testTan() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = _tan(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [-2.1850, 1.5574, 0.2027, 0.1003])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    #if os(iOS) || os(OSX)
    
    func testExpAccelerate() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = _expAccelerate(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [7.3891, 2.7183, 1.2214, 1.1052])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    func testLogAccelerate() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = _logAccelerate(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [0.6931, 0, -1.6094, -2.3026])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    func testCosAccelerate() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = _cosAccelerate(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [-0.4161, 0.5403, 0.9801, 0.9950])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    func testSinAccelerate() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = _sinAccelerate(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [0.9093, 0.8415, 0.1987, 0.0998])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    func testTanAccelerate() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = _tanAccelerate(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [-2.1850, 1.5574, 0.2027, 0.1003])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    #endif
    
    static var allTests: [(String, (MatrixFloatingPointFunctionsTests) -> () throws -> Void)] {
        return [
            ("testExp", testExp),
            ("testLog", testLog),
            ("testSin", testSin),
            ("testCos", testCos),
            ("testTan", testTan)
        ]
    }
    
}
