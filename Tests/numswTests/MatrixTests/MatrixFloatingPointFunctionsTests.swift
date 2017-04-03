import XCTest
@testable import numsw

class MatrixFloatingPointFunctionsTests: XCTestCase {
    
    func testSqrt() {
        let m = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
        XCTAssertEqualWithAccuracy(sqrt(m), Matrix([[1, 1.41421356],
                                                    [1.7320508, 2],
                                                    [2.2360679, 2.44949]]))
    }
    
    func testExp() {
        let m = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
        XCTAssertEqualWithAccuracy(exp(m), Matrix([[   2.71828183,    7.3890561 ],
                                                   [  20.08553692,   54.59815003],
                                                   [ 148.4131591 ,  403.42879349]]))
    }
    
    func testLog() {
        let m = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
        XCTAssertEqualWithAccuracy(log(m), Matrix([[ 0        ,  0.69314718],
                                                   [ 1.09861229,  1.38629436],
                                                   [ 1.60943791,  1.79175947]]))
    }
    
    func testSin() {
        let m = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
        XCTAssertEqualWithAccuracy(sin(m), Matrix([[ 0.84147098,  0.90929743],
                                                   [ 0.14112001, -0.7568025 ],
                                                   [-0.95892427, -0.2794155 ]]))
    }
    
    func testCos() {
        let m = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
        XCTAssertEqualWithAccuracy(cos(m), Matrix([[ 0.54030231, -0.41614684],
                                                   [-0.9899925 , -0.65364362],
                                                   [ 0.28366219,  0.96017029]]))
    }
    
    func testTan() {
        let m = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
        XCTAssertEqualWithAccuracy(tan(m), Matrix([[ 1.55740772, -2.18503986],
                                                   [-0.14254654,  1.15782128],
                                                   [-3.38051501, -0.29100619]]))
    }
    
    func testSqrtNormal() {
        let m = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
        XCTAssertEqualWithAccuracy(_sqrt(m), Matrix([[1, 1.41421356],
                                                    [1.7320508, 2],
                                                    [2.2360679, 2.44949]]))
    }
    
    func testExpNormal() {
        let m = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
        XCTAssertEqualWithAccuracy(_exp(m), Matrix([[   2.71828183,    7.3890561 ],
                                                   [  20.08553692,   54.59815003],
                                                   [ 148.4131591 ,  403.42879349]]))
    }
    
    func testLogNormal() {
        let m = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
        XCTAssertEqualWithAccuracy(_log(m), Matrix([[ 0        ,  0.69314718],
                                                   [ 1.09861229,  1.38629436],
                                                   [ 1.60943791,  1.79175947]]))
    }
    
    func testSinNormal() {
        let m = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
        XCTAssertEqualWithAccuracy(_sin(m), Matrix([[ 0.84147098,  0.90929743],
                                                   [ 0.14112001, -0.7568025 ],
                                                   [-0.95892427, -0.2794155 ]]))
    }
    
    func testCosNormal() {
        let m = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
        XCTAssertEqualWithAccuracy(_cos(m), Matrix([[ 0.54030231, -0.41614684],
                                                   [-0.9899925 , -0.65364362],
                                                   [ 0.28366219,  0.96017029]]))
    }
    
    func testTanNormal() {
        let m = Matrix([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
        XCTAssertEqualWithAccuracy(_tan(m), Matrix([[ 1.55740772, -2.18503986],
                                                   [-0.14254654,  1.15782128],
                                                   [-3.38051501, -0.29100619]]))
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
            ("testSqrt", testSqrt),
            ("testExp", testExp),
            ("testLog", testLog),
            ("testSin", testSin),
            ("testCos", testCos),
            ("testTan", testTan),
            ("testSqrtNormal", testSqrtNormal),
            ("testExpNormal", testExpNormal),
            ("testLogNormal", testLogNormal),
            ("testSinNormal", testSinNormal),
            ("testCosNormal", testCosNormal),
            ("testTanNormal", testTanNormal)
        ]
    }
    
}
