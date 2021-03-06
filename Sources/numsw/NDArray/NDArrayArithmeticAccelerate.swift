#if os(iOS) || os(OSX)
    
    import Accelerate
    
    // MARK: - Unary
    public prefix func - (arg: NDArray<Float>) -> NDArray<Float> {
        return unaryMinusAccelerate(arg)
    }
    
    public prefix func - (arg: NDArray<Double>) -> NDArray<Double> {
        return unaryMinusAccelerate(arg)
    }
    
    // MARK: - NDArray and scalar
    public func + (lhs: NDArray<Float>, rhs: Float) -> NDArray<Float> {
        return addAccelerate(lhs, rhs)
    }
    
    public func + (lhs: Float, rhs: NDArray<Float>) -> NDArray<Float> {
        return addAccelerate(rhs, lhs)
    }
    
    public func + (lhs: NDArray<Double>, rhs: Double) -> NDArray<Double> {
        return addAccelerate(lhs, rhs)
    }
    
    public func + (lhs: Double, rhs: NDArray<Double>) -> NDArray<Double> {
        return addAccelerate(rhs, lhs)
    }
    
    public func - (lhs: NDArray<Float>, rhs: Float) -> NDArray<Float> {
        return addAccelerate(lhs, -rhs)
    }
    
    public func - (lhs: Float, rhs: NDArray<Float>) -> NDArray<Float> {
        return addAccelerate(-rhs, lhs)
    }
    
    public func - (lhs: NDArray<Double>, rhs: Double) -> NDArray<Double> {
        return addAccelerate(lhs, -rhs)
    }
    
    public func - (lhs: Double, rhs: NDArray<Double>) -> NDArray<Double> {
        return addAccelerate(-rhs, lhs)
    }
    
    public func * (lhs: NDArray<Float>, rhs: Float) -> NDArray<Float> {
        return multiplyAccelerate(lhs, rhs)
    }
    
    public func * (lhs: Float, rhs: NDArray<Float>) -> NDArray<Float> {
        return multiplyAccelerate(rhs, lhs)
    }
    
    public func * (lhs: NDArray<Double>, rhs: Double) -> NDArray<Double> {
        return multiplyAccelerate(lhs, rhs)
    }
    
    public func * (lhs: Double, rhs: NDArray<Double>) -> NDArray<Double> {
        return multiplyAccelerate(rhs, lhs)
    }
    
    public func / (lhs: NDArray<Float>, rhs: Float) -> NDArray<Float> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func / (lhs: Float, rhs: NDArray<Float>) -> NDArray<Float> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func / (lhs: NDArray<Double>, rhs: Double) -> NDArray<Double> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func / (lhs: Double, rhs: NDArray<Double>) -> NDArray<Double> {
        return divideAccelerate(lhs, rhs)
    }
    
    // MARK: - NDArray and NDArray
    public func + (lhs: NDArray<Float>, rhs: NDArray<Float>) -> NDArray<Float> {
        return addAccelerate(lhs, rhs)
    }
    
    public func + (lhs: NDArray<Double>, rhs: NDArray<Double>) -> NDArray<Double> {
        return addAccelerate(lhs, rhs)
    }
    
    public func - (lhs: NDArray<Float>, rhs: NDArray<Float>) -> NDArray<Float> {
        return subtractAccelerate(lhs, rhs)
    }
    
    public func - (lhs: NDArray<Double>, rhs: NDArray<Double>) -> NDArray<Double> {
        return subtractAccelerate(lhs, rhs)
    }
    
    public func * (lhs: NDArray<Float>, rhs: NDArray<Float>) -> NDArray<Float> {
        return multiplyAccelerate(lhs, rhs)
    }
    
    public func * (lhs: NDArray<Double>, rhs: NDArray<Double>) -> NDArray<Double> {
        return multiplyAccelerate(lhs, rhs)
    }
    
    public func / (lhs: NDArray<Float>, rhs: NDArray<Float>) -> NDArray<Float> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func / (lhs: NDArray<Double>, rhs: NDArray<Double>) -> NDArray<Double> {
        return divideAccelerate(lhs, rhs)
    }
    
    // MARK: - Unary
    private func applyVDspFunc<T>(_ arg: NDArray<T>, _ vDspFunc: (UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> NDArray<T> {
        
        return NDArray(shape: arg.shape,
                       elements: applyVDspFunc(arg.elements, vDspFunc))
    }
    
    func unaryMinusAccelerate(_ arg: NDArray<Float>) -> NDArray<Float> {
        return applyVDspFunc(arg, vDSP_vneg)
    }
    
    func unaryMinusAccelerate(_ arg: NDArray<Double>) -> NDArray<Double> {
        return applyVDspFunc(arg, vDSP_vnegD)
    }
    
    // MARK: - NDArray and scalar
    private func applyVDspFunc<T>(_ lhs: NDArray<T>, _ rhs: T, _ vDspFunc: (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> NDArray<T> {

        return NDArray(shape: lhs.shape,
                       elements: applyVDspFunc(lhs.elements, rhs, vDspFunc))
    }
    private func applyVDspFunc<T>(_ lhs: T, _ rhs: NDArray<T>, _ vDspFunc: (UnsafePointer<T>, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> NDArray<T> {
        
        return NDArray(shape: rhs.shape,
                       elements: applyVDspFunc(lhs, rhs.elements, vDspFunc))
    }
    
    func addAccelerate(_ lhs: NDArray<Float>, _ rhs: Float) -> NDArray<Float> {
        return applyVDspFunc(lhs, rhs, vDSP_vsadd)
    }
    
    func addAccelerate(_ lhs: NDArray<Double>, _ rhs: Double) -> NDArray<Double> {
        return applyVDspFunc(lhs, rhs, vDSP_vsaddD)
    }
    
    func multiplyAccelerate(_ lhs: NDArray<Float>, _ rhs: Float) -> NDArray<Float> {
        return applyVDspFunc(lhs, rhs, vDSP_vsmul)
    }
    
    func multiplyAccelerate(_ lhs: NDArray<Double>, _ rhs: Double) -> NDArray<Double> {
        return applyVDspFunc(lhs, rhs, vDSP_vsmulD)
    }
    
    func divideAccelerate(_ lhs: NDArray<Float>, _ rhs: Float) -> NDArray<Float> {
        return applyVDspFunc(lhs, rhs, vDSP_vsdiv)
    }
    
    func divideAccelerate(_ lhs: Float, _ rhs: NDArray<Float>) -> NDArray<Float> {
        return applyVDspFunc(lhs, rhs, vDSP_svdiv)
    }
    
    func divideAccelerate(_ lhs: NDArray<Double>, _ rhs: Double) -> NDArray<Double> {
        return applyVDspFunc(lhs, rhs, vDSP_vsdivD)
    }
    
    func divideAccelerate(_ lhs: Double, _ rhs: NDArray<Double>) -> NDArray<Double> {
        return applyVDspFunc(lhs, rhs, vDSP_svdivD)
    }
    
    // MARK: - NDArray and NDArray
    private func applyVDspFunc<T>(_ lhs: NDArray<T>, _ rhs: NDArray<T>, _ vDspFunc: (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> NDArray<T> {
        
        precondition(lhs.shape == rhs.shape, "Two NDArrays have incompatible shape.")
        
        return NDArray(shape: lhs.shape,
                       elements: applyVDspFunc(lhs.elements, rhs.elements, vDspFunc))
    }
    
    func addAccelerate(_ lhs: NDArray<Float>, _ rhs: NDArray<Float>) -> NDArray<Float> {
        return applyVDspFunc(lhs, rhs, vDSP_vadd)
    }
    
    func addAccelerate(_ lhs: NDArray<Double>, _ rhs: NDArray<Double>) -> NDArray<Double> {
        return applyVDspFunc(lhs, rhs, vDSP_vaddD)
    }
    
    func subtractAccelerate(_ lhs: NDArray<Float>, _ rhs: NDArray<Float>) -> NDArray<Float> {
        return applyVDspFunc(rhs, lhs, vDSP_vsub)
    }
    
    func subtractAccelerate(_ lhs: NDArray<Double>, _ rhs: NDArray<Double>) -> NDArray<Double> {
        return applyVDspFunc(rhs, lhs, vDSP_vsubD)
    }
    
    func multiplyAccelerate(_ lhs: NDArray<Float>, _ rhs: NDArray<Float>) -> NDArray<Float> {
        return applyVDspFunc(lhs, rhs, vDSP_vmul)
    }
    
    func multiplyAccelerate(_ lhs: NDArray<Double>, _ rhs: NDArray<Double>) -> NDArray<Double> {
        return applyVDspFunc(lhs, rhs, vDSP_vmulD)
    }
    
    func divideAccelerate(_ lhs: NDArray<Float>, _ rhs: NDArray<Float>) -> NDArray<Float> {
        return applyVDspFunc(rhs, lhs, vDSP_vdiv)
    }
    
    func divideAccelerate(_ lhs: NDArray<Double>, _ rhs: NDArray<Double>) -> NDArray<Double> {
        return applyVDspFunc(rhs, lhs, vDSP_vdivD)
    }
    
#endif
