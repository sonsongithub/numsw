#if os(iOS) || os(OSX)
    
    import Accelerate
    
    // MARK: - Unary
    public prefix func - (arg: Matrix<Float>) -> Matrix<Float> {
        return unaryMinusAccelerate(arg)
    }
    
    public prefix func - (arg: Matrix<Double>) -> Matrix<Double> {
        return unaryMinusAccelerate(arg)
    }
    
    // MARK: - Matrix and scalar
    public func + (lhs: Matrix<Float>, rhs: Float) -> Matrix<Float> {
        return addAccelerate(lhs, rhs)
    }
    
    public func + (lhs: Float, rhs: Matrix<Float>) -> Matrix<Float> {
        return addAccelerate(rhs, lhs)
    }
    
    public func + (lhs: Matrix<Double>, rhs: Double) -> Matrix<Double> {
        return addAccelerate(lhs, rhs)
    }
    
    public func + (lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
        return addAccelerate(rhs, lhs)
    }
    
    public func - (lhs: Matrix<Float>, rhs: Float) -> Matrix<Float> {
        return addAccelerate(lhs, -rhs)
    }
    
    public func - (lhs: Float, rhs: Matrix<Float>) -> Matrix<Float> {
        return addAccelerate(-rhs, lhs)
    }
    
    public func - (lhs: Matrix<Double>, rhs: Double) -> Matrix<Double> {
        return addAccelerate(lhs, -rhs)
    }
    
    public func - (lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
        return addAccelerate(-rhs, lhs)
    }
    
    public func * (lhs: Matrix<Float>, rhs: Float) -> Matrix<Float> {
        return multiplyAccelerate(lhs, rhs)
    }
    
    public func * (lhs: Float, rhs: Matrix<Float>) -> Matrix<Float> {
        return multiplyAccelerate(rhs, lhs)
    }
    
    public func * (lhs: Matrix<Double>, rhs: Double) -> Matrix<Double> {
        return multiplyAccelerate(lhs, rhs)
    }
    
    public func * (lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
        return multiplyAccelerate(rhs, lhs)
    }
    
    public func / (lhs: Matrix<Float>, rhs: Float) -> Matrix<Float> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func / (lhs: Float, rhs: Matrix<Float>) -> Matrix<Float> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func / (lhs: Matrix<Double>, rhs: Double) -> Matrix<Double> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func / (lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
        return divideAccelerate(lhs, rhs)
    }
    
    // MARK: - Matrix and Matrix
    public func + (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
        return addAccelerate(lhs, rhs)
    }
    
    public func + (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
        return addAccelerate(lhs, rhs)
    }
    
    public func - (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
        return subtractAccelerate(lhs, rhs)
    }
    
    public func - (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
        return subtractAccelerate(lhs, rhs)
    }
    
    public func .* (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
        return elementWiseProductAccelerate(lhs, rhs)
    }
    
    public func .* (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
        return elementWiseProductAccelerate(lhs, rhs)
    }
    
    public func / (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func / (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
        return divideAccelerate(lhs, rhs)
    }
    
    // MARK: - Unary
    private func applyVDspFunc<T>(_ arg: Matrix<T>, _ vDspFunc: (UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> Matrix<T> {
        
        return Matrix(rows: arg.rows,
                      columns: arg.columns,
                      elements: applyVDspFunc(arg.elements, vDspFunc))
    }
    
    func unaryMinusAccelerate(_ arg: Matrix<Float>) -> Matrix<Float> {
        return applyVDspFunc(arg, vDSP_vneg)
    }
    
    func unaryMinusAccelerate(_ arg: Matrix<Double>) -> Matrix<Double> {
        return applyVDspFunc(arg, vDSP_vnegD)
    }
    
    // MARK: - Matrix and scalar
    private func applyVDspFunc<T>(_ lhs: Matrix<T>, _ rhs: T, _ vDspFunc: (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> Matrix<T> {

        return Matrix(rows: lhs.rows,
                      columns: lhs.columns,
                      elements: applyVDspFunc(lhs.elements, rhs, vDspFunc))
    }
    private func applyVDspFunc<T>(_ lhs: T, _ rhs: Matrix<T>, _ vDspFunc: (UnsafePointer<T>, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> Matrix<T> {

        return Matrix(rows: rhs.rows,
                      columns: rhs.columns,
                      elements: applyVDspFunc(lhs, rhs.elements, vDspFunc))
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
    
    // MARK: - Matrix and Matrix
    private func applyVDspFunc<T>(_ lhs: Matrix<T>, _ rhs: Matrix<T>, _ vDspFunc: (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> Matrix<T> {
        
        precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Two NDArrays have incompatible shape.")
        
        return Matrix(rows: lhs.rows,
                      columns: lhs.columns,
                      elements: applyVDspFunc(lhs.elements, rhs.elements, vDspFunc))
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
