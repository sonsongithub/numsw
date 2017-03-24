import Foundation

// MARK: - Accelerate
#if os(iOS) || os(OSX)
    
    import Accelerate
    
    public func sqrt(_ arg: Matrix<Float>) -> Matrix<Float> {
        return _sqrtAccelerate(arg)
    }
    
    public func sqrt(_ arg: Matrix<Double>) -> Matrix<Double> {
        return _sqrtAccelerate(arg)
    }
    
    public func exp(_ arg: Matrix<Float>) -> Matrix<Float> {
        return _expAccelerate(arg)
    }
    
    public func exp(_ arg: Matrix<Double>) -> Matrix<Double> {
        return _expAccelerate(arg)
    }
    
    public func log(_ arg: Matrix<Float>) -> Matrix<Float> {
        return _logAccelerate(arg)
    }
    
    public func log(_ arg: Matrix<Double>) -> Matrix<Double> {
        return _logAccelerate(arg)
    }
    
    public func sin(_ arg: Matrix<Float>) -> Matrix<Float> {
        return _sinAccelerate(arg)
    }
    
    public func sin(_ arg: Matrix<Double>) -> Matrix<Double> {
        return _sinAccelerate(arg)
    }
    
    public func cos(_ arg: Matrix<Float>) -> Matrix<Float> {
        return _cosAccelerate(arg)
    }
    
    public func cos(_ arg: Matrix<Double>) -> Matrix<Double> {
        return _cosAccelerate(arg)
    }
    
    public func tan(_ arg: Matrix<Float>) -> Matrix<Float> {
        return _tanAccelerate(arg)
    }
    
    public func tan(_ arg: Matrix<Double>) -> Matrix<Double> {
        return _tanAccelerate(arg)
    }
    
    private func applyVVFunc<T>(_ arg: Matrix<T>, _ vvFunc: (UnsafeMutablePointer<T>, UnsafePointer<T>, UnsafePointer<Int32>) -> Void) -> Matrix<T> {
        let inPointer = UnsafePointer(arg.elements)
        let outPointer = UnsafeMutablePointer<T>.allocate(capacity: arg.elements.count)
        defer { outPointer.deallocate(capacity: arg.elements.count) }
        
        var count = Int32(arg.elements.count)
        vvFunc(outPointer, inPointer, &count)
        
        return Matrix(rows: arg.rows,
                      columns: arg.columns,
                      elements: Array(UnsafeBufferPointer(start: outPointer, count: arg.elements.count)))
    }
    
    func _sqrtAccelerate(_ arg: Matrix<Float>) -> Matrix<Float> {
        return applyVVFunc(arg, vvsqrtf)
    }
    
    func _sqrtAccelerate(_ arg: Matrix<Double>) -> Matrix<Double> {
        return applyVVFunc(arg, vvsqrt)
    }
    
    func _expAccelerate(_ arg: Matrix<Float>) -> Matrix<Float> {
        return applyVVFunc(arg, vvexpf)
    }
    
    func _expAccelerate(_ arg: Matrix<Double>) -> Matrix<Double> {
        return applyVVFunc(arg, vvexp)
    }
    
    func _logAccelerate(_ arg: Matrix<Float>) -> Matrix<Float> {
        return applyVVFunc(arg, vvlogf)
    }
    
    func _logAccelerate(_ arg: Matrix<Double>) -> Matrix<Double> {
        return applyVVFunc(arg, vvlog)
    }
    
    func _sinAccelerate(_ arg: Matrix<Float>) -> Matrix<Float> {
        return applyVVFunc(arg, vvsinf)
    }
    
    func _sinAccelerate(_ arg: Matrix<Double>) -> Matrix<Double> {
        return applyVVFunc(arg, vvsin)
    }
    
    func _cosAccelerate(_ arg: Matrix<Float>) -> Matrix<Float> {
        return applyVVFunc(arg, vvcosf)
    }
    
    func _cosAccelerate(_ arg: Matrix<Double>) -> Matrix<Double> {
        return applyVVFunc(arg, vvcos)
    }
    
    func _tanAccelerate(_ arg: Matrix<Float>) -> Matrix<Float> {
        return applyVVFunc(arg, vvtanf)
    }
    
    func _tanAccelerate(_ arg: Matrix<Double>) -> Matrix<Double> {
        return applyVVFunc(arg, vvtan)
    }
    
#endif

// MARK: - Normal
public func sqrt<T: FloatingPointFunctions>(_ arg: Matrix<T>) -> Matrix<T> {
    return _sqrt(arg)
}

public func exp<T: FloatingPointFunctions>(_ arg: Matrix<T>) -> Matrix<T> {
    return _exp(arg)
}

public func log<T: FloatingPointFunctions>(_ arg: Matrix<T>) -> Matrix<T> {
    return _log(arg)
}

public func sin<T: FloatingPointFunctions>(_ arg: Matrix<T>) -> Matrix<T> {
    return _sin(arg)
}

public func cos<T: FloatingPointFunctions>(_ arg: Matrix<T>) -> Matrix<T> {
    return _cos(arg)
}

public func tan<T: FloatingPointFunctions>(_ arg: Matrix<T>) -> Matrix<T> {
    return _tan(arg)
}

func _sqrt<T: FloatingPointFunctions>(_ arg: Matrix<T>) -> Matrix<T> {
    return apply(arg, T.sqrt)
}

func _exp<T: FloatingPointFunctions>(_ arg: Matrix<T>) -> Matrix<T> {
    return apply(arg, T.exp)
}

func _log<T: FloatingPointFunctions>(_ arg: Matrix<T>) -> Matrix<T> {
    return apply(arg, T.log)
}

func _sin<T: FloatingPointFunctions>(_ arg: Matrix<T>) -> Matrix<T> {
    return apply(arg, T.sin)
}

func _cos<T: FloatingPointFunctions>(_ arg: Matrix<T>) -> Matrix<T> {
    return apply(arg, T.cos)
}

func _tan<T: FloatingPointFunctions>(_ arg: Matrix<T>) -> Matrix<T> {
    return apply(arg, T.tan)
}
