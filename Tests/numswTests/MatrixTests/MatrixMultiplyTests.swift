//
//  MatrixMultiplyTest.swift
//  numsw
//
//  Created by Araki Takehiro on 2017/03/04.
//
//

import XCTest
@testable import numsw

class MatrixMultiplyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMultiply() {
        let a = Matrix(rows: 2, columns: 2, elements: [1.0, 2.0, 1.0, 2.0])
        let b = Matrix(rows: 2, columns: 2, elements: [1.0, 0.0, 0.0, 1.0])
        
        let c = a * b
        
        XCTAssertEqual(c.elements, [1.0, 2.0, 1.0, 2.0])
    }
    
    func testScalarMultiply() {
        let a = Matrix(rows: 2, columns: 2, elements: [1.0, 2.0, 1.0, 2.0])
        let b = 10.0
        
        XCTAssertEqual((a*b).elements, [10.0, 20.0, 10.0, 20.0])
    }
    
    func testElementWiseMult() {
        let a = Matrix(rows: 2, columns: 2, elements: [1, 2, 3, 4.0])
        let b = Matrix(rows: 2, columns: 2, elements: [1, 3, 5, 7.0])
        
        XCTAssertEqual((a .* b).elements, [1.0, 6.0, 15.0, 28.0])
    }
    
    static var allTests: [(String, (Self) -> () throws -> Void)] {
        return [
            ("testMultiply", testMultiply),
            ("testScalarMultiply", testScalarMultiply),
            ("testElementWiseMult", testElementWiseMult),
        ]
    }
}
