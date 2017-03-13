
#if os(iOS) || os(OSX)
    
    import Accelerate
    
    public func *(lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
        return multiplyAccelerate(lhs, rhs)
    }
    
    public func *(lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
        return multiplyAccelerate(lhs, rhs)
    }
    
    func multiplyAccelerate(_ lhs: Matrix<Float>, _ rhs: Matrix<Float>) -> Matrix<Float> {
        precondition(lhs.columns == rhs.rows, "Matrices can't multiply.")
        
        let count = lhs.rows * rhs.columns
        
        let cElements = UnsafeMutablePointer<Float>.allocate(capacity: count)
        defer { cElements.deallocate(capacity: count) }
        
        vDSP_mmul(lhs.elements, 1,
                  rhs.elements, 1,
                  cElements, 1,
                  vDSP_Length(lhs.rows), vDSP_Length(rhs.columns), vDSP_Length(lhs.columns))
        
        return Matrix(rows: lhs.rows,
                      columns: rhs.columns,
                      elements: Array(UnsafeBufferPointer(start: cElements, count: count)))
    }
    
    func multiplyAccelerate(_ lhs: Matrix<Double>, _ rhs: Matrix<Double>) -> Matrix<Double> {
        precondition(lhs.columns == rhs.rows, "Matrices can't multiply.")
        
        let count = lhs.rows * rhs.columns
        
        let cElements = UnsafeMutablePointer<Double>.allocate(capacity: count)
        defer { cElements.deallocate(capacity: count) }
        
        vDSP_mmulD(lhs.elements, 1,
                   rhs.elements, 1,
                   cElements, 1,
                   vDSP_Length(lhs.rows), vDSP_Length(rhs.columns), vDSP_Length(lhs.columns))
        
        return Matrix(rows: lhs.rows,
                      columns: rhs.columns,
                      elements: Array(UnsafeBufferPointer(start: cElements, count: count)))
    }
    
    
#endif

public func *<T: Arithmetic>(_ lhs: Matrix<T>, _ rhs: Matrix<T>) -> Matrix<T> {
    return multiply(lhs, rhs)
}

func multiply<T: Arithmetic>(_ lhs: Matrix<T>, _ rhs: Matrix<T>) -> Matrix<T> {
    precondition(lhs.columns == rhs.rows, "Matrices can't multiply.")
    
    let m = lhs.rows
    let n = rhs.columns
    let p = lhs.columns
    let count = m * n

    let cElements = UnsafeMutablePointer<T>.allocate(capacity: count)
    defer { cElements.deallocate(capacity: count) }
    
    var ptr = cElements
    for i in 0..<m {
        for j in 0..<n {
            ptr.pointee = lhs[i, 0] * rhs[0, j]
            for k in 1..<p {
                ptr.pointee += lhs[i, k] * rhs[k, j]
            }
            ptr += 1
        }
    }
    
    return Matrix(rows: m,
                  columns: n,
                  elements: Array(UnsafeBufferPointer(start: cElements, count: count)))
}

