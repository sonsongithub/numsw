//
//  MatrixLogarithmTest.swift
//  numsw
//
//  Created by sonson on 2017/03/04.
//
//

import XCTest
@testable import numsw

class MatrixLogarithmTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExp() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = exp(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [7.3891, 2.7183, 1.2214, 1.1052])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    /// To be written
    func testExp2() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = exp2(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [4.0000, 2.0000, 1.1487, 1.0718])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    func testLog() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = log(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [0.6931, 0, -1.6094, -2.3026])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    func testLog10() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = log10(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [0.3010, 0, -0.6990, -1.0000])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
//    func testLogb() {
//        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
//        let m2 = logb(m1)
//        let ans = Matrix(rows: 2, columns: 2, elements: [0.3010, 0, -0.6990, -1.0000])
//        m2.show()
//        let error = frobeniusNorm(ans - m2)
//        XCTAssert(error < 0.000001)
//    }
}
