import XCTest
@testable import numsw

class NDArrayReduceTests: XCTestCase {
    
    func testMin() {
        let a = NDArray(shape: [2, 3, 4], elements: (0..<2*3*4).reversed())
        XCTAssertEqual(a.min(), 0)
        XCTAssertEqual(a.min(along: 0),
                       NDArray(shape: [3, 4],
                               elements: [11, 10, 9, 8,
                                          7, 6, 5, 4,
                                          3, 2, 1, 0]))
        XCTAssertEqual(a.min(along: 1),
                       NDArray(shape: [2, 4],
                               elements: [15, 14, 13, 12,
                                          3, 2, 1, 0]))
        
        XCTAssertEqual(a.min(along: 2),
                       NDArray(shape: [2, 3],
                               elements: [20, 16, 12,
                                          8, 4, 0]))
    }
    
    func testMax() {
        let a = NDArray(shape: [2, 3, 4], elements: [Int](0..<2*3*4))
        XCTAssertEqual(a.max(), 23)
        XCTAssertEqual(a.max(along: 0),
                       NDArray(shape: [3, 4],
                               elements: [12, 13, 14, 15,
                                          16, 17, 18, 19,
                                          20, 21, 22, 23]))
        XCTAssertEqual(a.max(along: 1),
                       NDArray(shape: [2, 4],
                               elements: [8, 9, 10, 11,
                                          20, 21, 22, 23]))
        
        XCTAssertEqual(a.max(along: 2),
                       NDArray(shape: [2, 3],
                               elements: [3, 7, 11,
                                          15, 19, 23]))
    }
    
    func testSum() {
        let a = NDArray(shape: [2, 3, 4], elements: [Int](0..<2*3*4))
        XCTAssertEqual(a.sum(), 276)
        XCTAssertEqual(a.sum(along: 0),
                       NDArray(shape: [3, 4],
                               elements: [12, 14, 16, 18,
                                          20, 22, 24, 26,
                                          28, 30, 32, 34]))
        XCTAssertEqual(a.sum(along: 1),
                       NDArray(shape: [2, 4],
                               elements: [12, 15, 18, 21,
                                          48, 51, 54, 57]))
        
        XCTAssertEqual(a.sum(along: 2),
                       NDArray(shape: [2, 3],
                               elements: [6, 22, 38,
                                          54, 70, 86]))
    }
    
    func testMean() {
        let a = NDArray(shape: [2, 3, 4], elements: (0..<2*3*4).map(Double.init))
        XCTAssertEqual(a.mean(), 11.5, accuracy: 1e-5)
        XCTAssertEqualWithAccuracy(a.mean(along: 0),
                                   NDArray(shape: [3, 4],
                                           elements: [6, 7, 8, 9,
                                                      10, 11, 12, 13,
                                                      14, 15, 16, 17]))
        XCTAssertEqualWithAccuracy(a.mean(along: 1),
                                   NDArray(shape: [2, 4],
                                           elements: [4, 5, 6, 7,
                                                      16, 17, 18, 19]))
        
        XCTAssertEqualWithAccuracy(a.mean(along: 2),
                                   NDArray(shape: [2, 3],
                                           elements: [1.5, 5.5, 9.5,
                                                      13.5, 17.5, 21.5]))
    }
    
    func testMinNormal() {
        let a = NDArray(shape: [2, 3, 4], elements: (0..<2*3*4).reversed())
        XCTAssertEqual(_min(a), 0)
        XCTAssertEqual(_min(a, along: 0),
                       NDArray(shape: [3, 4],
                               elements: [11, 10, 9, 8,
                                          7, 6, 5, 4,
                                          3, 2, 1, 0]))
        XCTAssertEqual(_min(a, along: 1),
                       NDArray(shape: [2, 4],
                               elements: [15, 14, 13, 12,
                                          3, 2, 1, 0]))
        
        XCTAssertEqual(_min(a, along: 2),
                       NDArray(shape: [2, 3],
                               elements: [20, 16, 12,
                                          8, 4, 0]))
    }
    
    func testMaxNormal() {
        let a = NDArray(shape: [2, 3, 4], elements: [Int](0..<2*3*4))
        XCTAssertEqual(_max(a), 23)
        XCTAssertEqual(_max(a, along: 0),
                       NDArray(shape: [3, 4],
                               elements: [12, 13, 14, 15,
                                          16, 17, 18, 19,
                                          20, 21, 22, 23]))
        XCTAssertEqual(_max(a, along: 1),
                       NDArray(shape: [2, 4],
                               elements: [8, 9, 10, 11,
                                          20, 21, 22, 23]))
        
        XCTAssertEqual(_max(a, along: 2),
                       NDArray(shape: [2, 3],
                               elements: [3, 7, 11,
                                          15, 19, 23]))
    }
    
    func testSumNormal() {
        let a = NDArray(shape: [2, 3, 4], elements: [Int](0..<2*3*4))
        XCTAssertEqual(_sum(a), 276)
        XCTAssertEqual(_sum(a, along: 0),
                       NDArray(shape: [3, 4],
                               elements: [12, 14, 16, 18,
                                          20, 22, 24, 26,
                                          28, 30, 32, 34]))
        XCTAssertEqual(_sum(a, along: 1),
                       NDArray(shape: [2, 4],
                               elements: [12, 15, 18, 21,
                                          48, 51, 54, 57]))
        
        XCTAssertEqual(_sum(a, along: 2),
                       NDArray(shape: [2, 3],
                               elements: [6, 22, 38,
                                          54, 70, 86]))
    }
    
    func testMeanNormal() {
        let a = NDArray(shape: [2, 3, 4], elements: (0..<2*3*4).map(Double.init))
        XCTAssertEqual(_mean(a), 11.5, accuracy: 1e-5)
        XCTAssertEqualWithAccuracy(_mean(a, along: 0),
                                   NDArray(shape: [3, 4],
                                           elements: [6, 7, 8, 9,
                                                      10, 11, 12, 13,
                                                      14, 15, 16, 17]))
        XCTAssertEqualWithAccuracy(_mean(a, along: 1),
                                   NDArray(shape: [2, 4],
                                           elements: [4, 5, 6, 7,
                                                      16, 17, 18, 19]))
        
        XCTAssertEqualWithAccuracy(_mean(a, along: 2),
                                   NDArray(shape: [2, 3],
                                           elements: [1.5, 5.5, 9.5,
                                                      13.5, 17.5, 21.5]))
    }
    
    #if os(iOS) || os(OSX)
    
    func testMinAccelerate() {
        do {
            let a = NDArray(shape: [2, 3, 4], elements: (0..<2*3*4).reversed().map(Float.init))
            XCTAssertEqual(_minAccelerate(a), 0)
            XCTAssertEqual(_minAccelerate(a, along: 0),
                           NDArray(shape: [3, 4],
                                   elements: [11, 10, 9,
                                              8, 7, 6,
                                              5, 4, 3,
                                              2, 1, 0]))
            XCTAssertEqual(_minAccelerate(a, along: 1),
                           NDArray(shape: [2, 4],
                                   elements: [15, 14, 13, 12,
                                              3, 2, 1, 0]))
            
            XCTAssertEqual(_minAccelerate(a, along: 2),
                           NDArray(shape: [2, 3],
                                   elements: [20, 16, 12,
                                              8, 4, 0]))
        }
        do {
            let a = NDArray(shape: [2, 3, 4], elements: (0..<2*3*4).reversed().map(Double.init))
            XCTAssertEqual(_minAccelerate(a), 0)
            XCTAssertEqual(_minAccelerate(a, along: 0),
                           NDArray(shape: [3, 4],
                                   elements: [11, 10, 9,
                                              8, 7, 6,
                                              5, 4, 3,
                                              2, 1, 0]))
            XCTAssertEqual(_minAccelerate(a, along: 1),
                           NDArray(shape: [2, 4],
                                   elements: [15, 14, 13, 12,
                                              3, 2, 1, 0]))
            
            XCTAssertEqual(_minAccelerate(a, along: 2),
                           NDArray(shape: [2, 3],
                                   elements: [20, 16, 12,
                                              8, 4, 0]))
        }
    }
    
    func testMaxAccelerate() {
        do {
            let a = NDArray(shape: [2, 3, 4], elements: (0..<2*3*4).map(Float.init))
            XCTAssertEqual(_maxAccelerate(a), 23)
            XCTAssertEqual(_maxAccelerate(a, along: 0),
                           NDArray(shape: [3, 4],
                                   elements: [12, 13, 14, 15,
                                              16, 17, 18, 19,
                                              20, 21, 22, 23]))
            XCTAssertEqual(_maxAccelerate(a, along: 1),
                           NDArray(shape: [2, 4],
                                   elements: [8, 9, 10, 11,
                                              20, 21, 22, 23]))
            
            XCTAssertEqual(_maxAccelerate(a, along: 2),
                           NDArray(shape: [2, 3],
                                   elements: [3, 7, 11,
                                              15, 19, 23]))
        }
        do {
            let a = NDArray(shape: [2, 3, 4], elements: (0..<2*3*4).map(Double.init))
            XCTAssertEqual(_maxAccelerate(a), 23)
            XCTAssertEqual(_maxAccelerate(a, along: 0),
                           NDArray(shape: [3, 4],
                                   elements: [12, 13, 14, 15,
                                              16, 17, 18, 19,
                                              20, 21, 22, 23]))
            XCTAssertEqual(_maxAccelerate(a, along: 1),
                           NDArray(shape: [2, 4],
                                   elements: [8, 9, 10, 11,
                                              20, 21, 22, 23]))
            
            XCTAssertEqual(_maxAccelerate(a, along: 2),
                           NDArray(shape: [2, 3],
                                   elements: [3, 7, 11,
                                              15, 19, 23]))
        }
    }
    
    func testSumAccelerate() {
        do {
            let a = NDArray(shape: [2, 3, 4], elements: (0..<2*3*4).map(Float.init))
            XCTAssertEqual(_sumAccelerate(a), 276)
            XCTAssertEqual(_sumAccelerate(a, along: 0),
                           NDArray(shape: [3, 4],
                                   elements: [12, 14, 16, 18,
                                              20, 22, 24, 26,
                                              28, 30, 32, 34]))
            XCTAssertEqual(_sumAccelerate(a, along: 1),
                           NDArray(shape: [2, 4],
                                   elements: [12, 15, 18, 21,
                                              48, 51, 54, 57]))
            
            XCTAssertEqual(_sumAccelerate(a, along: 2),
                           NDArray(shape: [2, 3],
                                   elements: [6, 22, 38,
                                              54, 70, 86]))
        }
        do {
            let a = NDArray(shape: [2, 3, 4], elements: (0..<2*3*4).map(Double.init))
            XCTAssertEqual(_sumAccelerate(a), 276)
            XCTAssertEqual(_sumAccelerate(a, along: 0),
                           NDArray(shape: [3, 4],
                                   elements: [12, 14, 16, 18,
                                              20, 22, 24, 26,
                                              28, 30, 32, 34]))
            XCTAssertEqual(_sumAccelerate(a, along: 1),
                           NDArray(shape: [2, 4],
                                   elements: [12, 15, 18, 21,
                                              48, 51, 54, 57]))
            
            XCTAssertEqual(_sumAccelerate(a, along: 2),
                           NDArray(shape: [2, 3],
                                   elements: [6, 22, 38,
                                              54, 70, 86]))
        }
    }
    
    func testMeanAccelerate() {
        let a = NDArray(shape: [2, 3, 4], elements: (0..<2*3*4).map(Double.init))
        XCTAssertEqual(_meanAccelerate(a), 11.5, accuracy: 1e-5)
        XCTAssertEqualWithAccuracy(_meanAccelerate(a, along: 0),
                                   NDArray(shape: [3, 4],
                                           elements: [6, 7, 8, 9,
                                                      10, 11, 12, 13,
                                                      14, 15, 16, 17]))
        XCTAssertEqualWithAccuracy(_meanAccelerate(a, along: 1),
                                   NDArray(shape: [2, 4],
                                           elements: [4, 5, 6, 7,
                                                      16, 17, 18, 19]))
        
        XCTAssertEqualWithAccuracy(_meanAccelerate(a, along: 2),
                                   NDArray(shape: [2, 3],
                                           elements: [1.5, 5.5, 9.5,
                                                      13.5, 17.5, 21.5]))
    }
    
    #endif
    
    static var allTests: [(String, (NDArrayReduceTests) -> () throws -> Void)] {
        return [
            ("testMin", testMin),
            ("testMax", testMax),
            ("testSum", testSum),
            ("testMean", testMean),
            ("testMinNormal", testMinNormal),
            ("testMaxNormal", testMaxNormal),
            ("testSumNormal", testSumNormal),
            ("testMeanNormal", testMeanNormal)
        ]
    }
}
