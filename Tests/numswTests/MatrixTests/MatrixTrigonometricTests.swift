//
//  MatrixTrigonometricTest.swift
//  numsw
//
//  Created by sonson on 2017/03/04.
//
//

import XCTest
@testable import numsw

class MatrixTrigonometricTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCos() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = cos(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [-0.4161, 0.5403, 0.9801, 0.9950])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    func testSin() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = sin(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [0.9093, 0.8415, 0.1987, 0.0998])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    func testTan() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = tan(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [-2.1850, 1.5574, 0.2027, 0.1003])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    static var allTests: [(String, (Self) -> () throws -> Void)] {
        return [
            ("testSin", testSin),
            ("testCos", testCos),
            ("testTan", testTan),
        ]
    }
}
