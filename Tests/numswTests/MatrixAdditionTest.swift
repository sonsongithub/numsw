//
//  MatrixAdditionTest.swift
//  numsw
//
//  Created by sonson on 2017/03/04.
//
//

import XCTest
@testable import numsw

class MatrixAdditionTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = Matrix(rows: 2, columns: 2, elements: [1.0, 1.0, 0.3, 1.0])
        let ans = Matrix(rows: 2, columns: 2, elements: [3.0, 2.0, 0.5, 1.1])
        let m3 = m1 + m2
        let error = frobeniusNorm(ans + (-1) * m3)
        XCTAssert(error < 0.0001)
    }
    
    func testExample2() {
        let m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = Matrix(rows: 2, columns: 2, elements: [1.0, 1.0, 0.3, 1.0])
        let ans = Matrix(rows: 2, columns: 2, elements: [1.0, 0.0, -0.1, -0.9])
        let m3 = m1 - m2
        let error = frobeniusNorm(ans + (-1) * m3)
        XCTAssert(error < 0.000001)
    }
    
    func testExample3() {
        let  m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let ans = Matrix(rows: 2, columns: 2, elements: [-2.0, -1.0, -0.2, -0.1])
        let m2 = -m1
        let error = frobeniusNorm(ans + (-1) * m2)
        XCTAssert(error < 0.000001)
    }
    
    func testExample4() {
        var m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = Matrix(rows: 2, columns: 2, elements: [1.0, 1.0, 0.3, 1.0])
        let ans = Matrix(rows: 2, columns: 2, elements: [3.0, 2.0, 0.5, 1.1])
        m1 += m2
        let error = frobeniusNorm(ans + (-1) * m1)
        XCTAssert(error < 0.0001)
    }
    
    func testExample5() {
        var m1 = Matrix(rows: 2, columns: 2, elements: [2.0, 1.0, 0.2, 0.1])
        let m2 = Matrix(rows: 2, columns: 2, elements: [1.0, 1.0, 0.3, 1.0])
        let ans = Matrix(rows: 2, columns: 2, elements: [1.0, 0.0, -0.1, -0.9])
        m1 -= m2
        let error = frobeniusNorm(ans + (-1) * m1)
        XCTAssert(error < 0.000001)
    }
    
    static var allTests: [(String, (MatrixAdditionTest) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
            ("testExample2", testExample2),
            ("testExample3", testExample3),
            ("testExample4", testExample4),
            ("testExample5", testExample5),
        ]
    }
}
