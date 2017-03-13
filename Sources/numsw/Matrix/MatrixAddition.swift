////
////  MatrixAddition.swift
////  numsw
////
////  Created by sonson on 2017/03/04.
////
////
//
//import Foundation
//import Accelerate
//
//// MARK: - Addition
//
//public func add(_ lhs: Matrix, rhs: Double) -> Matrix {
//    let newElements = lhs.elements.map { (value) -> Double in
//        return value + rhs
//    }
//    return Matrix(rows: lhs.rows, columns: lhs.columns, elements: Array(UnsafeBufferPointer(start: newElements, count: lhs.count)))
//}
//
//public func add(_ lhs: Matrix, rhs: Matrix) -> Matrix {
//    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix dimensions not compatible with addition")
//    
//    let cElements = UnsafeMutablePointer<Double>.allocate(capacity: lhs.count)
//    defer { cElements.deallocate(capacity: lhs.count) }
//    
//    memcpy(cElements, rhs.elements, rhs.count * MemoryLayout<Double>.size)
//    
//    cblas_daxpy(Int32(lhs.count), 1.0, lhs.elements, 1, cElements, 1)
//    
//    return Matrix(rows: lhs.rows, columns: lhs.columns, elements: Array(UnsafeBufferPointer(start: cElements, count: lhs.count)))
//}
//
//public func += (lhs: inout Matrix, rhs: Double) {
//    lhs = lhs + rhs
//}
//
//public func += (lhs: inout Matrix, rhs: Matrix) {
//    lhs = lhs + rhs
//}
//
//public func + (lhs: Matrix, rhs: Double) -> Matrix {
//    return add(lhs, rhs: rhs)
//}
//
//public func + (lhs: Matrix, rhs: Matrix) -> Matrix {
//    return add(lhs, rhs: rhs)
//}
//
//// MARK: - Subtraction
//
//public func subtract(_ lhs: Matrix, rhs: Double) -> Matrix {
//    let newElements = lhs.elements.map { (value) -> Double in
//        return value - rhs
//    }
//    return Matrix(rows: lhs.rows, columns: lhs.columns, elements: Array(UnsafeBufferPointer(start: newElements, count: lhs.count)))
//}
//
//public func subtract(_ lhs: Matrix, rhs: Matrix) -> Matrix {
//    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix dimensions not compatible with addition")
//    
//    let cElements = UnsafeMutablePointer<Double>.allocate(capacity: lhs.count)
//    defer { cElements.deallocate(capacity: lhs.count) }
//
//    memcpy(cElements, lhs.elements, lhs.count * MemoryLayout<Double>.size)
//    
//    cblas_daxpy(Int32(lhs.count), -1.0, rhs.elements, 1, cElements, 1)
//    
//    return Matrix(rows: lhs.rows, columns: lhs.columns, elements: Array(UnsafeBufferPointer(start: cElements, count: lhs.count)))
//}
//
//public func -= (lhs: inout Matrix, rhs: Double) {
//    lhs = lhs - rhs
//}
//
//public func -= (lhs: inout Matrix, rhs: Matrix) {
//    lhs = lhs - rhs
//}
//
//public func - (lhs: Matrix, rhs: Double) -> Matrix {
//    return subtract(lhs, rhs: rhs)
//}
//
//public func - (lhs: Matrix, rhs: Matrix) -> Matrix {
//    return subtract(lhs, rhs: rhs)
//}
//
//// MARK: - Prefix
//
//public prefix func - (lhs: Matrix) -> Matrix {
//    let newElements = lhs.elements.map { (value) -> Double in
//        return -value
//    }
//    return Matrix(rows: lhs.rows, columns: lhs.columns, elements: Array(UnsafeBufferPointer(start: newElements, count: lhs.count)))
//}
