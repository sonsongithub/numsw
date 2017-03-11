import XCTest
@testable import numswTests

XCTMain([
     testCase(numswTests.allTests),
     testCase(MatrixLogarithmTests.allTests),
     testCase(MatrixBasicTests.allTests),
     testCase(MatrixAdditionTests.allTests),
     testCase(MatrixMultiplyTests.allTests),
     testCase(MatrixSubscriptTests.allTests),
     testCase(MatrixInvertTests.allTests),
     testCase(MatrixTransposeTests.allTests),
     testCase(MatrixDivideTests.allTests),
     testCase(MatrixRangeTests.allTests),
     testCase(MatrixTrigonometricTests.allTests),
])
