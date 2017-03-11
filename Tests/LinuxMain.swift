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
     testCase(NDArrayTests.allTests),
     testCase(NDArrayTransformationTests.allTests),
])

