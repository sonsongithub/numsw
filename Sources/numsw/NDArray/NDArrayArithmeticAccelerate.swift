#if os(iOS) || os(OSX)
    
    import Accelerate
    
    // unary
    public prefix func -(arg: NDArray<Float>) -> NDArray<Float> {
        return unaryMinusAccelerate(arg)
    }
    
    public prefix func -(arg: NDArray<Double>) -> NDArray<Double> {
        return unaryMinusAccelerate(arg)
    }
    
    // NDArray and scalar
    public func +(lhs: NDArray<Float>, rhs: Float) -> NDArray<Float> {
        return addAccelerate(lhs, rhs)
    }
    
    public func +(lhs: Float, rhs: NDArray<Float>) -> NDArray<Float> {
        return addAccelerate(rhs, lhs)
    }
    
    public func +(lhs: NDArray<Double>, rhs: Double) -> NDArray<Double> {
        return addAccelerate(lhs, rhs)
    }
    
    public func +(lhs: Double, rhs: NDArray<Double>) -> NDArray<Double> {
        return addAccelerate(rhs, lhs)
    }
    
    public func -(lhs: NDArray<Float>, rhs: Float) -> NDArray<Float> {
        return addAccelerate(lhs, -rhs)
    }
    
    public func -(lhs: Float, rhs: NDArray<Float>) -> NDArray<Float> {
        return addAccelerate(-rhs, lhs)
    }
    
    public func -(lhs: NDArray<Double>, rhs: Double) -> NDArray<Double> {
        return addAccelerate(lhs, -rhs)
    }
    
    public func -(lhs: Double, rhs: NDArray<Double>) -> NDArray<Double> {
        return addAccelerate(-rhs, lhs)
    }
    
    public func *(lhs: NDArray<Float>, rhs: Float) -> NDArray<Float> {
        return multiplyAccelerate(lhs, rhs)
    }
    
    public func *(lhs: Float, rhs: NDArray<Float>) -> NDArray<Float> {
        return multiplyAccelerate(rhs, lhs)
    }
    
    public func *(lhs: NDArray<Double>, rhs: Double) -> NDArray<Double> {
        return multiplyAccelerate(lhs, rhs)
    }
    
    public func *(lhs: Double, rhs: NDArray<Double>) -> NDArray<Double> {
        return multiplyAccelerate(rhs, lhs)
    }
    
    public func /(lhs: NDArray<Float>, rhs: Float) -> NDArray<Float> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func /(lhs: Float, rhs: NDArray<Float>) -> NDArray<Float> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func /(lhs: NDArray<Double>, rhs: Double) -> NDArray<Double> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func /(lhs: Double, rhs: NDArray<Double>) -> NDArray<Double> {
        return divideAccelerate(lhs, rhs)
    }
    
    // NDArray and NDArray
    public func +(lhs: NDArray<Float>, rhs: NDArray<Float>) -> NDArray<Float> {
        return addAccelerate(lhs, rhs)
    }
    
    public func +(lhs: NDArray<Double>, rhs: NDArray<Double>) -> NDArray<Double> {
        return addAccelerate(lhs, rhs)
    }
    
    public func -(lhs: NDArray<Float>, rhs: NDArray<Float>) -> NDArray<Float> {
        return subtractAccelerate(lhs, rhs)
    }
    
    public func -(lhs: NDArray<Double>, rhs: NDArray<Double>) -> NDArray<Double> {
        return subtractAccelerate(lhs, rhs)
    }
    
    public func *(lhs: NDArray<Float>, rhs: NDArray<Float>) -> NDArray<Float> {
        return multiplyAccelerate(lhs, rhs)
    }
    
    public func *(lhs: NDArray<Double>, rhs: NDArray<Double>) -> NDArray<Double> {
        return multiplyAccelerate(lhs, rhs)
    }
    
    public func /(lhs: NDArray<Float>, rhs: NDArray<Float>) -> NDArray<Float> {
        return divideAccelerate(lhs, rhs)
    }
    
    public func /(lhs: NDArray<Double>, rhs: NDArray<Double>) -> NDArray<Double> {
        return divideAccelerate(lhs, rhs)
    }
    
    // unary
    private func applyVDspFunc<T>(_ arg: NDArray<T>,
                               _ vDspFunc: (UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> NDArray<T> {
        
        let out = UnsafeMutablePointer<T>.allocate(capacity: arg.elements.count)
        defer { out.deallocate(capacity: arg.elements.count) }
        
        vDspFunc(arg.elements, 1,
                 out, 1, vDSP_Length(arg.elements.count))
        
        return NDArray(shape: arg.shape,
                       elements: Array(UnsafeBufferPointer(start: out, count: arg.elements.count)))
    }
    
    func unaryMinusAccelerate(_ arg: NDArray<Float>) -> NDArray<Float> {
        return applyVDspFunc(arg, vDSP_vneg)
    }
    
    func unaryMinusAccelerate(_ arg: NDArray<Double>) -> NDArray<Double> {
        return applyVDspFunc(arg, vDSP_vnegD)
    }
    
    // NDArray and scalar
    private func applyVDspFunc<T>(_ lhs: NDArray<T>,
                               _ rhs: T,
                               _ vDspFunc: (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> NDArray<T> {
        
        let out = UnsafeMutablePointer<T>.allocate(capacity: lhs.elements.count)
        defer { out.deallocate(capacity: lhs.elements.count) }
        
        var rhs = rhs
        vDspFunc(lhs.elements, 1,
                 &rhs,
                 out, 1, vDSP_Length(lhs.elements.count))
        
        return NDArray(shape: lhs.shape,
                       elements: Array(UnsafeBufferPointer(start: out, count: lhs.elements.count)))
    }
    private func applyVDspFunc<T>(_ lhs: T,
                               _ rhs: NDArray<T>,
                               _ vDspFunc: (UnsafePointer<T>, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> NDArray<T> {
        
        let out = UnsafeMutablePointer<T>.allocate(capacity: rhs.elements.count)
        defer { out.deallocate(capacity: rhs.elements.count) }
        
        var lhs = lhs
        vDspFunc(&lhs,
                 rhs.elements, 1,
                 out, 1, vDSP_Length(rhs.elements.count))
        
        return NDArray(shape: rhs.shape,
                       elements: Array(UnsafeBufferPointer(start: out, count: rhs.elements.count)))
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
    
    // NDArray and NDArray
    private func applyVDspFunc<T>(_ lhs: NDArray<T>,
                               _ rhs: NDArray<T>,
                               _ vDspFunc: (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> NDArray<T> {
        
        precondition(lhs.shape == rhs.shape, "Two NDArrays have incompatible shape.")
        
        let out = UnsafeMutablePointer<T>.allocate(capacity: lhs.elements.count)
        defer { out.deallocate(capacity: lhs.elements.count) }
        
        vDspFunc(lhs.elements, 1,
                 rhs.elements, 1,
                 out, 1,
                 vDSP_Length(lhs.elements.count))
        
        return NDArray(shape: lhs.shape,
                       elements: Array(UnsafeBufferPointer(start: out, count: lhs.elements.count)))
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
