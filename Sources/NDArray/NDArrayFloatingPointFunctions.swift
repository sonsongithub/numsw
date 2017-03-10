
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

func _sqrt<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    var inPointer = UnsafePointer(arg.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: arg.elements.count)
    defer { outPointer.deallocate(capacity: arg.elements.count) }
    
    var p = outPointer
    for _ in 0..<arg.elements.count {
        p.pointee = T.sqrt(inPointer.pointee)
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: arg.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: arg.elements.count)))
}


func _exp<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    var inPointer = UnsafePointer(arg.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: arg.elements.count)
    defer { outPointer.deallocate(capacity: arg.elements.count) }
    
    var p = outPointer
    for _ in 0..<arg.elements.count {
        p.pointee = T.exp(inPointer.pointee)
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: arg.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: arg.elements.count)))
}

func _log<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    var inPointer = UnsafePointer(arg.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: arg.elements.count)
    defer { outPointer.deallocate(capacity: arg.elements.count) }
    
    var p = outPointer
    for _ in 0..<arg.elements.count {
        p.pointee = T.log(inPointer.pointee)
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: arg.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: arg.elements.count)))
}

func _sin<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    var inPointer = UnsafePointer(arg.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: arg.elements.count)
    defer { outPointer.deallocate(capacity: arg.elements.count) }
    
    var p = outPointer
    for _ in 0..<arg.elements.count {
        p.pointee = T.sin(inPointer.pointee)
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: arg.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: arg.elements.count)))
}

func _cos<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    var inPointer = UnsafePointer(arg.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: arg.elements.count)
    defer { outPointer.deallocate(capacity: arg.elements.count) }
    
    var p = outPointer
    for _ in 0..<arg.elements.count {
        p.pointee = T.cos(inPointer.pointee)
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: arg.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: arg.elements.count)))
}

func _tan<T: FloatingPointFunctions>(_ arg: NDArray<T>) -> NDArray<T> {
    var inPointer = UnsafePointer(arg.elements)
    let outPointer = UnsafeMutablePointer<T>.allocate(capacity: arg.elements.count)
    defer { outPointer.deallocate(capacity: arg.elements.count) }
    
    var p = outPointer
    for _ in 0..<arg.elements.count {
        p.pointee = T.tan(inPointer.pointee)
        p += 1
        inPointer += 1
    }
    
    return NDArray(shape: arg.shape,
                   elements: Array(UnsafeBufferPointer(start: outPointer, count: arg.elements.count)))
}
