import XCTest
@testable import numsw

class numswTests: XCTestCase {
    func testExample() {
        let x = Matrix.range(from: 0, to: 10, stride: 0.01)
        let y = cos(x/2)
        y.show()
    }
    
    func testMaskedRider() {
        let x = Matrix(rows: 2, columns: 6, elements: [1, 2, 5, 9, 13, 15, 1, 1, 1, 1, 1, 1])
        let y = Matrix(rows: 1, columns: 6, elements: [1, 2, 3, 5, 10, 50])


        let xx = x * x.transposed()
        x.transposed().show()

        let a = xx.inverted()
        print("------------a")
        a.show()
        print("------------")
        
//        logY = np.log(Y)
//        A = np.dot(logY, np.dot(np.transpose(X), a))
//        print(A)
        let logy = log(y)
//        logy.show()
        
        print("------------b")
        let b = x.transposed() * a
        b.show()
        print("-------------")
        
        let A = logy * b
        A.show()
        
        A.elements[0]
        A.elements[1]
        
        let x_p = Matrix.range(from: 0, to: 10, stride: 0.1)
        let y_p = exp(A.elements[0] * x_p + A.elements[1])

        y_p.show()
    }

    static var allTests: [(String, (numswTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
