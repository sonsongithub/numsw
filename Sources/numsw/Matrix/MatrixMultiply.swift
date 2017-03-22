
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
    
    /* multiply m*p matrix A and p*n matrix B, return m*n matrix C */
    
    let m = lhs.rows
    let n = rhs.columns
    let p = lhs.columns
    let count = m * n

    let cElements = UnsafeMutablePointer<T>.allocate(capacity: count)
    defer { cElements.deallocate(capacity: count) }
    
    // init C[i,j] with A[i,0] * B[0,j]
    var ptr = cElements
    var lp = UnsafePointer(lhs.elements)
    var rp = UnsafePointer(rhs.elements)
    for i in 0..<m {
        for j in 0..<n {
            ptr.pointee = lp[i*p] * rp[j]
            ptr += 1
        }
    }
    
    // add A[i,k] * B[k,j] for C[i,j]
    for i in 0..<m {
        lp = UnsafePointer(lhs.elements) + i*p + 1
        for k in 1..<p {
            rp = UnsafePointer(rhs.elements) + k*n
            ptr = cElements + i*n
            for _ in 0..<n {
                ptr.pointee += lp.pointee * rp.pointee
                rp += 1
                ptr += 1
            }
            lp += 1
        }
    }
    
    return Matrix(rows: m,
                  columns: n,
                  elements: Array(UnsafeBufferPointer(start: cElements, count: count)))
}

