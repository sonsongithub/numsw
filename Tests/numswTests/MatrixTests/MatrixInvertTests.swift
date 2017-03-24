import XCTest
@testable import numsw

class MatrixInvertTests: XCTestCase {
    
    #if os(iOS) || os(OSX)
    
    func testInvert() {
        do {
            let mat = Matrix<Float>(rows: 2, columns: 2, elements: [0.0, 1.0, 2.0, 3.0])
            let inv = try mat.inverted()
            XCTAssertEqual(inv.elements, [-1.5, 0.5, 1, 0])
        } catch {
            XCTFail("\(error)")
        }
        do {
            let mat = Matrix(rows: 2, columns: 2, elements: [0.0, 1.0, 2.0, 3.0])
            let inv = try mat.inverted()
            XCTAssertEqual(inv.elements, [-1.5, 0.5, 1, 0])
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testIrregularInvert() {
        do {
            let mat = Matrix<Float>([[1, 2], [2, 4]])
            XCTAssertThrowsError(try mat.inverted())
        }
        do {
            let mat = Matrix<Double>([[1, 2], [2, 4]])
            XCTAssertThrowsError(try mat.inverted())
        }
    }
    
    #endif
    
    static var allTests: [(String, (MatrixInvertTests) -> () throws -> Void)] {
        return [
            // ("testInvert", testInvert),
        ]
    }
}
