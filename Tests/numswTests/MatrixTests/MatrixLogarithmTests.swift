//
//  MatrixLogarithmTest.swift
//  numsw
//
//  Created by sonson on 2017/03/04.
//
//

import XCTest
@testable import numsw

class MatrixLogarithmTests: XCTestCase {
    
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
    
    func testLog() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = log(m1)
        let ans = Matrix(rows: 2, columns: 2, elements: [0.6931, 0, -1.6094, -2.3026])
        m2.show()
        let error = frobeniusNorm(ans - m2)
        XCTAssert(error < 0.000001)
    }
    
    static var allTests: [(String, (MatrixLogarithmTests) -> () throws -> Void)] {
        return [
            ("testExp", testExp),
            ("testLog", testLog),
        ]
    }
}
