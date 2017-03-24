import XCTest
@testable import numsw

class numswTests: XCTestCase {
    func testExample() {
        let x = Matrix.range(from: 0, to: 10, stride: 0.01)
        let y = cos(x/2)
        y.show()
    }
    
    #if os(iOS) || os(OSX)
    
    func testMaskedRider() {
        do {
            let x = Matrix<Double>(rows: 2, columns: 6, elements: [1, 2, 5, 9, 13, 15, 1, 1, 1, 1, 1, 1])
            let y = Matrix<Double>(rows: 1, columns: 6, elements: [1, 2, 3, 5, 10, 50])

            let xx = x * x.transposed()
            x.transposed().show()

            let a = try xx.inverted()
            let logy = log(y)
            let b = x.transposed() * a
            let A = logy * b
            let x_p = Matrix.range(from: 0, to: 10, stride: 0.1)
            let y_p = exp(A.elements[0] * x_p + A.elements[1])
            y_p.show()
        } catch {
            XCTFail("\(error)")
        }
    }
    
    #endif

    static var allTests: [(String, (numswTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample)
        ]
    }
}
