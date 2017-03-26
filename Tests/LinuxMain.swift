import XCTest
@testable import numswTests

XCTMain([
     testCase(numswTests.allTests),
     testCase(MatrixInvertTests.allTests),
     testCase(MatrixMultiplyTests.allTests),
     testCase(MatrixRangeTests.allTests),
     testCase(MatrixSubscriptTests.allTests),
     testCase(MatrixTransposeTests.allTests),
     testCase(MatrixCreationTests.allTests),
     testCase(MatrixTransformationTests.allTests),
     testCase(MatrixFloatingPointFunctionsTests.allTests),
     testCase(MatrixArithmeticTests.allTests),
     testCase(NDArrayArithmeticTests.allTests),
     testCase(NDArrayBoolTests.allTests),
     testCase(NDArrayCompoundAssignmentTests.allTests),
     testCase(NDArrayCreationTests.allTests),
     testCase(NDArrayFloatingPointFunctionsTests.allTests),
     testCase(NDArrayPerformanceTests.allTests),
     testCase(NDArrayRandomTests.allTests),
     testCase(NDArrayReduceTests.allTests),
     testCase(NDArrayStackTests.allTests),
     testCase(NDArraySubscriptTests.allTests),
     testCase(NDArrayTransformationTests.allTests)
])
