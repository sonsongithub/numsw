
#if os(iOS) || os(OSX)
    
    import Accelerate
    
    // unary
    public prefix func -(arg: Matrix<Float>) -> Matrix<Float> {
        return unaryMinusAccelerate(arg)
    }
    
    public prefix func -(arg: Matrix<Double>) -> Matrix<Double> {
        return unaryMinusAccelerate(arg)
    }
    
    // Matrix and scalar
    public func +(lhs: Matrix<Float>, rhs: Float) -> Matrix<Float> {
        return addAccelerate(lhs, rhs)
    }
    
    public func +(lhs: Float, rhs: Matrix<Float>) -> Matrix<Float> {
        return addAccelerate(rhs, lhs)
    }
    
    public func +(lhs: Matrix<Double>, rhs: Double) -> Matrix<Double> {
        return addAccelerate(lhs, rhs)
    }
    
    public func +(lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
        return addAccelerate(rhs, lhs)
    }
    
    
    public func -(lhs: Matrix<Float>, rhs: Float) -> Matrix<Float> {
        return addAccelerate(lhs, -rhs)
    }
    
    public func -(lhs: Float, rhs: Matrix<Float>) -> Matrix<Float> {
        return addAccelerate(-rhs, lhs)
    }
    
    public func -(lhs: Matrix<Double>, rhs: Double) -> Matrix<Double> {
        return addAccelerate(lhs, -rhs)
    }
    
    public func -(lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
        return addAccelerate(-rhs, lhs)
    }
    
    
    public func *(lhs: Matrix<Float>, rhs: Float) -> Matrix<Float> {
        return multiplyAccelerate(lhs, rhs)
    }
    
    public func *(lhs: Float, rhs: Matrix<Float>) -> Matrix<Float> {
        return multiplyAccelerate(rhs, lhs)
    }
    
    public func *(lhs: Matrix<Double>, rhs: Double) -> Matrix<Double> {
        return multiplyAccelerate(lhs, rhs)
    }
    
    public func *(lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
        return multiplyAccelerate(rhs, lhs)
    }
    
    
    public func /(lhs: Matrix<Float>, rhs: Float) -> Matrix<Float> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func /(lhs: Float, rhs: Matrix<Float>) -> Matrix<Float> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func /(lhs: Matrix<Double>, rhs: Double) -> Matrix<Double> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func /(lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
        return divideAccelerate(lhs, rhs)
    }
    
    // Matrix and Matrix
    public func +(lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
        return addAccelerate(lhs, rhs)
    }
    
    public func +(lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
        return addAccelerate(lhs, rhs)
    }
    
    public func -(lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
        return subtractAccelerate(lhs, rhs)
    }
    
    public func -(lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
        return subtractAccelerate(lhs, rhs)
    }
    
    public func .*(lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
        return elementWiseProductAccelerate(lhs, rhs)
    }
    
    public func .*(lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
        return elementWiseProductAccelerate(lhs, rhs)
    }
    
    public func /(lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func /(lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
        return divideAccelerate(lhs, rhs)
    }
    
    
    // unary
    private func applyVDspFunc<T>(_ arg: Matrix<T>,
                               _ vDspFunc: (UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length)->Void) -> Matrix<T> {
        
        let out = UnsafeMutablePointer<T>.allocate(capacity: arg.elements.count)
        defer { out.deallocate(capacity: arg.elements.count) }
        
        vDspFunc(arg.elements, 1,
                 out, 1, vDSP_Length(arg.elements.count))
        
        return Matrix(rows: arg.rows,
                      columns: arg.columns,
                      elements: Array(UnsafeBufferPointer(start: out, count: arg.elements.count)))
    }
    
    func unaryMinusAccelerate(_ arg: Matrix<Float>) -> Matrix<Float> {
        return applyVDspFunc(arg, vDSP_vneg)
    }
    
    func unaryMinusAccelerate(_ arg: Matrix<Double>) -> Matrix<Double> {
        return applyVDspFunc(arg, vDSP_vnegD)
    }
    
    // Matrix and scalar
    private func applyVDspFunc<T>(_ lhs: Matrix<T>,
                               _ rhs: T,
                               _ vDspFunc: (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length)->Void) -> Matrix<T> {
        
        let out = UnsafeMutablePointer<T>.allocate(capacity: lhs.elements.count)
        defer { out.deallocate(capacity: lhs.elements.count) }
        
        var rhs = rhs
        vDspFunc(lhs.elements, 1,
                 &rhs,
                 out, 1, vDSP_Length(lhs.elements.count))
        
        return Matrix(rows: lhs.rows,
                      columns: lhs.columns,
                      elements: Array(UnsafeBufferPointer(start: out, count: lhs.elements.count)))
    }
    private func applyVDspFunc<T>(_ lhs: T,
                               _ rhs: Matrix<T>,
                               _ vDspFunc: (UnsafePointer<T>, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length)->Void) -> Matrix<T> {
        
        let out = UnsafeMutablePointer<T>.allocate(capacity: rhs.elements.count)
        defer { out.deallocate(capacity: rhs.elements.count) }
        
        var lhs = lhs
        vDspFunc(&lhs,
                 rhs.elements, 1,
                 out, 1, vDSP_Length(rhs.elements.count))
        
        return Matrix(rows: rhs.rows,
                      columns: rhs.columns,
                      elements: Array(UnsafeBufferPointer(start: out, count: rhs.elements.count)))
    }
    
    func addAccelerate(_ lhs: Matrix<Float>, _ rhs: Float) -> Matrix<Float> {
        return applyVDspFunc(lhs, rhs, vDSP_vsadd)
    }
    
    func addAccelerate(_ lhs: Matrix<Double>, _ rhs: Double) -> Matrix<Double> {
        return applyVDspFunc(lhs, rhs, vDSP_vsaddD)
    }
    
    func multiplyAccelerate(_ lhs: Matrix<Float>, _ rhs: Float) -> Matrix<Float> {
        return applyVDspFunc(lhs, rhs, vDSP_vsmul)
    }
    
    func multiplyAccelerate(_ lhs: Matrix<Double>, _ rhs: Double) -> Matrix<Double> {
        return applyVDspFunc(lhs, rhs, vDSP_vsmulD)
    }
    
    func divideAccelerate(_ lhs: Matrix<Float>, _ rhs: Float) -> Matrix<Float> {
        return applyVDspFunc(lhs, rhs, vDSP_vsdiv)
    }
    
    func divideAccelerate(_ lhs: Float, _ rhs: Matrix<Float>) -> Matrix<Float> {
        return applyVDspFunc(lhs, rhs, vDSP_svdiv)
    }
    
    func divideAccelerate(_ lhs: Matrix<Double>, _ rhs: Double) -> Matrix<Double> {
        return applyVDspFunc(lhs, rhs, vDSP_vsdivD)
    }
    
    func divideAccelerate(_ lhs: Double, _ rhs: Matrix<Double>) -> Matrix<Double> {
        return applyVDspFunc(lhs, rhs, vDSP_svdivD)
    }
    
    // Matrix and Matrix
    private func applyVDspFunc<T>(_ lhs: Matrix<T>,
                               _ rhs: Matrix<T>,
                               _ vDspFunc: (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length)->Void) -> Matrix<T> {
        
        precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Two NDArrays have incompatible shape.")
        
        let out = UnsafeMutablePointer<T>.allocate(capacity: lhs.elements.count)
        defer { out.deallocate(capacity: lhs.elements.count) }
        
        vDspFunc(lhs.elements, 1,
                 rhs.elements, 1,
                 out, 1,
                 vDSP_Length(lhs.elements.count))
        
        return Matrix(rows: lhs.rows,
                      columns: lhs.columns,
                      elements: Array(UnsafeBufferPointer(start: out, count: lhs.elements.count)))
    }
    
    func addAccelerate(_ lhs: Matrix<Float>, _ rhs: Matrix<Float>) -> Matrix<Float> {
        return applyVDspFunc(lhs, rhs, vDSP_vadd)
    }
    
    func addAccelerate(_ lhs: Matrix<Double>, _ rhs: Matrix<Double>) -> Matrix<Double> {
        return applyVDspFunc(lhs, rhs, vDSP_vaddD)
    }
    
    func subtractAccelerate(_ lhs: Matrix<Float>, _ rhs: Matrix<Float>) -> Matrix<Float> {
        return applyVDspFunc(rhs, lhs, vDSP_vsub)
    }
    
    func subtractAccelerate(_ lhs: Matrix<Double>, _ rhs: Matrix<Double>) -> Matrix<Double> {
        return applyVDspFunc(rhs, lhs, vDSP_vsubD)
    }
    
    func elementWiseProductAccelerate(_ lhs: Matrix<Float>, _ rhs: Matrix<Float>) -> Matrix<Float> {
        return applyVDspFunc(lhs, rhs, vDSP_vmul)
    }
    
    func elementWiseProductAccelerate(_ lhs: Matrix<Double>, _ rhs: Matrix<Double>) -> Matrix<Double> {
        return applyVDspFunc(lhs, rhs, vDSP_vmulD)
    }
    
    func divideAccelerate(_ lhs: Matrix<Float>, _ rhs: Matrix<Float>) -> Matrix<Float> {
        return applyVDspFunc(rhs, lhs, vDSP_vdiv)
    }
    
    func divideAccelerate(_ lhs: Matrix<Double>, _ rhs: Matrix<Double>) -> Matrix<Double> {
        return applyVDspFunc(rhs, lhs, vDSP_vdivD)
    }
    
#endif
