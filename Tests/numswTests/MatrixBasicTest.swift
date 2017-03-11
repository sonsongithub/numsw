//
//  MatrixBasicTest.swift
//  numsw
//
//  Created by sonson on 2017/03/04.
//
//

import XCTest
@testable import numsw

class MatrixBasicTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEyeMatrix() {
        let ones = Matrix.eye(size: 3)
        let ans  = Matrix(rows: 3, columns: 3, elements: [1, 0, 0, 0, 1, 0, 0, 0, 1])
        XCTAssertEqual(ones.elements, ans.elements)
    }
    
    func testOnesMatrix() {
        let ones = Matrix.ones(rows: 4, columns: 2)
        let ans  = Matrix(rows: 4, columns: 2, elements: [1, 1, 1, 1, 1, 1, 1, 1])
        XCTAssertEqual(ones.elements, ans.elements)
    }
    
    func testZerosMatrix() {
        let ones = Matrix.zeros(rows: 4, columns: 2)
        let ans  = Matrix(rows: 4, columns: 2, elements: [0, 0, 0, 0, 0, 0, 0, 0])
        XCTAssertEqual(ones.elements, ans.elements)
    }
    
    func testArrayInit() {
        let mat = Matrix([[0, 1], [2, 3], [4, 5]])
        
        XCTAssertEqual(mat.rows, 3)
        XCTAssertEqual(mat.columns, 2)
        XCTAssertEqual(mat.elements, [0.0, 1, 2, 3, 4, 5])
    }
    
    static var allTests: [(String, (MatrixBasicTest) -> () throws -> Void)] {
        return [
            ("testEyeMatrix", testEyeMatrix),
            ("testOnesMatrix", testOnesMatrix),
            ("testZerosMatrix", testZerosMatrix),
            ("testArrayInit", testArrayInit),
        ]
    }
}
