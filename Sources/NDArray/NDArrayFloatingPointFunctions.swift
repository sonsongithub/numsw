
import Foundation

#if os(iOS) || os(OSX) || true // TODO: remove true
    
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
    
#else
    
    // TODO: Copy and paste here
    
#endif

public protocol FloatingPointFunctions {
    
    static func sqrt(_ arg: Self) -> Self
    
    static func exp(_ arg: Self) -> Self
    static func log(_ arg: Self) -> Self
    
    static func sin(_ arg: Self) -> Self
    static func cos(_ arg: Self) -> Self
    static func tan(_ arg: Self) -> Self
}

extension Float: FloatingPointFunctions {
    public static func sqrt(_ arg: Float) -> Float {
        return Foundation.sqrt(arg)
    }
    
    public static func exp(_ arg: Float) -> Float {
        return Foundation.exp(arg)
    }
    
    public static func log(_ arg: Float) -> Float {
        return Foundation.log(arg)
    }
    
    public static func sin(_ arg: Float) -> Float {
        return Foundation.sin(arg)
    }
    
    public static func cos(_ arg: Float) -> Float {
        return Foundation.cos(arg)
    }
    
    public static func tan(_ arg: Float) -> Float {
        return Foundation.tan(arg)
    }
}

extension Double: FloatingPointFunctions {
    public static func sqrt(_ arg: Double) -> Double {
        return Foundation.sqrt(arg)
    }
    
    public static func exp(_ arg: Double) -> Double {
        return Foundation.exp(arg)
    }
    
    public static func log(_ arg: Double) -> Double {
        return Foundation.log(arg)
    }
    
    public static func sin(_ arg: Double) -> Double {
        return Foundation.sin(arg)
    }
    
    public static func cos(_ arg: Double) -> Double {
        return Foundation.cos(arg)
    }
    
    public static func tan(_ arg: Double) -> Double {
        return Foundation.tan(arg)
    }
}

private func _sqrt<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    let elements = arg.elements.map { T.sqrt($0) }
    return NDArray(shape: arg.shape, elements: elements)
}


private func _exp<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    let elements = arg.elements.map { T.exp($0) }
    return NDArray(shape: arg.shape, elements: elements)
}

private func _log<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    let elements = arg.elements.map { T.log($0) }
    return NDArray(shape: arg.shape, elements: elements)
}

private func _sin<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    let elements = arg.elements.map { T.sin($0) }
    return NDArray(shape: arg.shape, elements: elements)
}

private func _cos<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    let elements = arg.elements.map { T.cos($0) }
    return NDArray(shape: arg.shape, elements: elements)
}

private func _tan<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    let elements = arg.elements.map { T.tan($0) }
    return NDArray(shape: arg.shape, elements: elements)
}
