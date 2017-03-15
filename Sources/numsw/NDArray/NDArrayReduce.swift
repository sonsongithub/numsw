#if os(iOS) || os(OSX)
    
    import Accelerate
    
    // TODO: need extension
//    extension NDArray where T == Float {
//        func min() -> Float {
//            return _minAccelerate(self)
//        }
//    }
    
    func _minAccelerate(_ arg: NDArray<Float>) -> Float {
        var out: Float = 0
        vDSP_minv(arg.elements, 1, &out, vDSP_Length(arg.elements.count))
        return out
    }
    
    func _minAccelerate(_ arg: NDArray<Double>) -> Double {
        var out: Double = 0
        vDSP_minvD(arg.elements, 1, &out, vDSP_Length(arg.elements.count))
        return out
    }
    
    func _maxAccelerate(_ arg: NDArray<Float>) -> Float {
        var out: Float = 0
        vDSP_maxv(arg.elements, 1, &out, vDSP_Length(arg.elements.count))
        return out
    }
    
    func _maxAccelerate(_ arg: NDArray<Double>) -> Double {
        var out: Double = 0
        vDSP_maxvD(arg.elements, 1, &out, vDSP_Length(arg.elements.count))
        return out
    }
    
    func _sumAccelerate(_ arg: NDArray<Float>) -> Float {
        var out: Float = 0
        vDSP_sve(arg.elements, 1, &out, vDSP_Length(arg.elements.count))
        return out
    }
    
    func _sumAccelerate(_ arg: NDArray<Double>) -> Double {
        var out: Double = 0
        vDSP_sveD(arg.elements, 1, &out, vDSP_Length(arg.elements.count))
        return out
    }
    
    func _meanAccelerate(_ arg: NDArray<Float>) -> Float {
        var out: Float = 0
        vDSP_meanv(arg.elements, 1, &out, vDSP_Length(arg.elements.count))
        return out
    }
    
    func _meanAccelerate(_ arg: NDArray<Double>) -> Double {
        var out: Double = 0
        vDSP_meanvD(arg.elements, 1, &out, vDSP_Length(arg.elements.count))
        return out
    }
    
    private func reduce<T>(_ arg: NDArray<T>,
                        along axis: Int,
                        handler: (UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Length) -> Void) -> NDArray<T> {
        var axis = axis
        if axis < 0 {
            axis += arg.shape.count
        }
        
        precondition(0 <= axis && axis < arg.shape.count, "Invalid axis.")
        
        let outShape = arg.shape.removed(at: axis)
        let count = arg.elements.count / arg.shape[axis]
        
        let outPointer = UnsafeMutablePointer<T>.allocate(capacity: count)
        defer { outPointer.deallocate(capacity: count) }
        
        let majorSize = arg.shape.prefix(upTo: axis).reduce(1, *)
        let minorSize = arg.shape.dropFirst(axis+1).reduce(1, *)
        
        var op = outPointer
        for major in 0..<majorSize {
            for minor in 0..<minorSize {
                var ip = UnsafePointer(arg.elements)
                ip += major*minorSize*arg.shape[axis] + minor
                handler(ip, minorSize, op, vDSP_Length(arg.shape[axis]))
                op += 1
            }
        }
        
        return NDArray(shape: outShape,
                       elements: Array(UnsafeBufferPointer(start: outPointer, count: count)))
    }
    
    func _minAccelerate(_ arg: NDArray<Float>, along axis: Int) -> NDArray<Float> {
        return reduce(arg, along: axis, handler: vDSP_minv)
    }
    
    func _minAccelerate(_ arg: NDArray<Double>, along axis: Int) -> NDArray<Double> {
        return reduce(arg, along: axis, handler: vDSP_minvD)
    }
    
    func _maxAccelerate(_ arg: NDArray<Float>, along axis: Int) -> NDArray<Float> {
        return reduce(arg, along: axis, handler: vDSP_maxv)
    }
    
    func _maxAccelerate(_ arg: NDArray<Double>, along axis: Int) -> NDArray<Double> {
        return reduce(arg, along: axis, handler: vDSP_maxvD)
    }
    
    func _sumAccelerate(_ arg: NDArray<Float>, along axis: Int) -> NDArray<Float> {
        return reduce(arg, along: axis, handler: vDSP_sve)
    }
    
    func _sumAccelerate(_ arg: NDArray<Double>, along axis: Int) -> NDArray<Double> {
        return reduce(arg, along: axis, handler: vDSP_sveD)
    }
    
    func _meanAccelerate(_ arg: NDArray<Float>, along axis: Int) -> NDArray<Float> {
        return _sumAccelerate(arg, along: axis) / Float(arg.shape[axis])
    }
    
    func _meanAccelerate(_ arg: NDArray<Double>, along axis: Int) -> NDArray<Double> {
        return _sumAccelerate(arg, along: axis) / Double(arg.shape[axis])
    }
    
#endif

extension NDArray where T: Comparable {
    
    public func min() -> T {
        return _min(self)
    }
    
    public func max() -> T {
        return _max(self)
    }
    
    public func min(along axis: Int) -> NDArray<T> {
        return _min(self, along: axis)
    }
    
    public func max(along axis: Int) -> NDArray<T> {
        return _max(self, along: axis)
    }
    
}

extension NDArray where T: Arithmetic {
    
    public func sum() -> T {
        return _sum(self)
    }
    
    public func sum(along axis: Int) -> NDArray<T> {
        return _sum(self, along: axis)
    }
}

extension NDArray where T: Arithmetic & FloatingPoint {
    
    public func mean() -> T {
        return _mean(self)
    }
    
    public func mean(along axis: Int) -> NDArray<T> {
        return _mean(self, along: axis)
    }
}

func _min<T: Comparable>(_ arg: NDArray<T>) -> T {
    return arg.elements.min()!
}

func _max<T: Comparable>(_ arg: NDArray<T>) -> T {
    return arg.elements.max()!
}

func _sum<T: Arithmetic>(_ arg: NDArray<T>) -> T {
    let initial = arg.elements.first!
    return arg.elements.dropFirst().reduce(initial, +)
}

func _mean<T: Arithmetic & FloatingPoint>(_ arg: NDArray<T>) -> T {
    return _sum(arg) / T(arg.elements.count)
}

private func reduce<T>(_ arg: NDArray<T>, along axis: Int, handler: (T, T) -> T) -> NDArray<T> {
    var axis = axis
    if axis < 0 {
        axis += arg.shape.count
    }
    
    precondition(0 <= axis && axis < arg.shape.count, "Invalid axis.")
    
    let outShape = arg.shape.removed(at: axis)
    let count = arg.elements.count / arg.shape[axis]
    
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: count)
    defer { outPointer.deallocate(capacity: count) }
    
    let majorSize = arg.shape.prefix(upTo: axis).reduce(1, *)
    let minorSize = arg.shape.dropFirst(axis+1).reduce(1, *)
    
    var op = outPointer
    for major in 0..<majorSize {
        for minor in 0..<minorSize {
            var ip = UnsafePointer(arg.elements)
            // init
            ip += major*minorSize*arg.shape[axis] + minor
            op.pointee = ip.pointee
            // reduce rest
            ip += minorSize
            for _ in 1..<arg.shape[axis] {
                op.pointee = handler(ip.pointee, op.pointee)
                ip += minorSize
            }
            op += 1
        }
    }
    
    return NDArray(shape: outShape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: count)))
}

func _min<T: Comparable>(_ arg: NDArray<T>, along axis: Int) -> NDArray<T> {
    return reduce(arg, along: axis, handler: min)
}

func _max<T: Comparable>(_ arg: NDArray<T>, along axis: Int) -> NDArray<T> {
    return reduce(arg, along: axis, handler: max)
}

func _sum<T: Arithmetic>(_ arg: NDArray<T>, along axis: Int) -> NDArray<T> {
    return reduce(arg, along: axis, handler: +)
}

func _mean<T: Arithmetic & FloatingPoint>(_ arg: NDArray<T>, along axis: Int) -> NDArray<T> {
    return _sum(arg, along: axis) / T(arg.shape[axis])
}
