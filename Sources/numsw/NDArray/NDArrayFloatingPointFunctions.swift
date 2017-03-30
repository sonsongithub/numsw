import Foundation

#if os(iOS) || os(OSX)
    
    import Accelerate
    
    public func sqrt(_ arg: NDArray<Float>) -> NDArray<Float> {
        return _sqrtAccelerate(arg)
    }
    
    public func sqrt(_ arg: NDArray<Double>) -> NDArray<Double> {
        return _sqrtAccelerate(arg)
    }
    
    public func exp(_ arg: NDArray<Float>) -> NDArray<Float> {
        return _expAccelerate(arg)
    }
    
    public func exp(_ arg: NDArray<Double>) -> NDArray<Double> {
        return _expAccelerate(arg)
    }
    
    public func log(_ arg: NDArray<Float>) -> NDArray<Float> {
        return _logAccelerate(arg)
    }
    
    public func log(_ arg: NDArray<Double>) -> NDArray<Double> {
        return _logAccelerate(arg)
    }
    
    public func sin(_ arg: NDArray<Float>) -> NDArray<Float> {
        return _sinAccelerate(arg)
    }
    
    public func sin(_ arg: NDArray<Double>) -> NDArray<Double> {
        return _sinAccelerate(arg)
    }
    
    public func cos(_ arg: NDArray<Float>) -> NDArray<Float> {
        return _cosAccelerate(arg)
    }
    
    public func cos(_ arg: NDArray<Double>) -> NDArray<Double> {
        return _cosAccelerate(arg)
    }
    
    public func tan(_ arg: NDArray<Float>) -> NDArray<Float> {
        return _tanAccelerate(arg)
    }
    
    public func tan(_ arg: NDArray<Double>) -> NDArray<Double> {
        return _tanAccelerate(arg)
    }
    
    private func applyVVFunc<T>(_ arg: NDArray<T>, _ vvFunc: (UnsafeMutablePointer<T>, UnsafePointer<T>, UnsafePointer<Int32>) -> Void) -> NDArray<T> {
        let inPointer = UnsafePointer(arg.elements)
        let outPointer = UnsafeMutablePointer<T>.allocate(capacity: arg.elements.count)
        defer { outPointer.deallocate(capacity: arg.elements.count) }
        
        var count = Int32(arg.elements.count)
        vvFunc(outPointer, inPointer, &count)
        
        return NDArray(shape: arg.shape,
                       elements: Array(UnsafeBufferPointer(start: outPointer, count: arg.elements.count)))
    }
    
    func _sqrtAccelerate(_ arg: NDArray<Float>) -> NDArray<Float> {
        return applyVVFunc(arg, vvsqrtf)
    }
    
    func _sqrtAccelerate(_ arg: NDArray<Double>) -> NDArray<Double> {
        return applyVVFunc(arg, vvsqrt)
    }
    
    func _expAccelerate(_ arg: NDArray<Float>) -> NDArray<Float> {
        return applyVVFunc(arg, vvexpf)
    }
    
    func _expAccelerate(_ arg: NDArray<Double>) -> NDArray<Double> {
        return applyVVFunc(arg, vvexp)
    }
    
    func _logAccelerate(_ arg: NDArray<Float>) -> NDArray<Float> {
        return applyVVFunc(arg, vvlogf)
    }
    
    func _logAccelerate(_ arg: NDArray<Double>) -> NDArray<Double> {
        return applyVVFunc(arg, vvlog)
    }
    
    func _sinAccelerate(_ arg: NDArray<Float>) -> NDArray<Float> {
        return applyVVFunc(arg, vvsinf)
    }
    
    func _sinAccelerate(_ arg: NDArray<Double>) -> NDArray<Double> {
        return applyVVFunc(arg, vvsin)
    }
    
    func _cosAccelerate(_ arg: NDArray<Float>) -> NDArray<Float> {
        return applyVVFunc(arg, vvcosf)
    }
    
    func _cosAccelerate(_ arg: NDArray<Double>) -> NDArray<Double> {
        return applyVVFunc(arg, vvcos)
    }
    
    func _tanAccelerate(_ arg: NDArray<Float>) -> NDArray<Float> {
        return applyVVFunc(arg, vvtanf)
    }
    
    func _tanAccelerate(_ arg: NDArray<Double>) -> NDArray<Double> {
        return applyVVFunc(arg, vvtan)
    }
    
#endif

public func sqrt<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    return _sqrt(arg)
}

public func exp<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    return _exp(arg)
}

public func log<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    return _log(arg)
}

public func sin<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    return _sin(arg)
}

public func cos<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    return _cos(arg)
}

public func tan<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    return _tan(arg)
}

func _sqrt<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    return apply(arg, T.sqrt)
}

func _exp<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    return apply(arg, T.exp)
}

func _log<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    return apply(arg, T.log)
}

func _sin<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    return apply(arg, T.sin)
}

func _cos<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    return apply(arg, T.cos)
}

func _tan<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    return apply(arg, T.tan)
}
