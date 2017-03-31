#if os(Linux)
    import Glibc
    import SwiftShims
#else
    import Darwin
#endif

// MARK: - Random
func cs_arc4random_uniform(_ upperBound: UInt32 = UINT32_MAX) -> UInt32 {
    #if os(Linux)
        return _swift_stdlib_cxx11_mt19937_uniform(upperBound)
    #else
        return arc4random_uniform(upperBound)
    #endif
}

func _uniform<T: FloatingPoint>(low: T = 0, high: T = 1) -> T {
    return (high-low)*(T(cs_arc4random_uniform(UInt32.max)) / T(UInt32.max))+low
}

// MARK: - High order functions

func apply<T, R>(_ arg: [T], _ handler: (T) -> R) -> [R] {
    var inPointer = UnsafePointer(arg)
    let outPointer = UnsafeMutablePointer<R>.allocate(capacity: arg.count)
    defer { outPointer.deallocate(capacity: arg.count) }
    
    var p = outPointer
    for _ in 0..<arg.count {
        p.pointee = handler(inPointer.pointee)
        p += 1
        inPointer += 1
    }
    
    return [R](UnsafeBufferPointer(start: outPointer, count: arg.count))
}

func combine<T, U, R>(_ lhs: [T], _ rhs: [U], _ handler: (T, U) -> R) -> [R] {
    precondition(lhs.count == rhs.count, "Two arrays have incompatible size.")
    
    var lhsPointer = UnsafePointer(lhs)
    var rhsPointer = UnsafePointer(rhs)
    let outPointer = UnsafeMutablePointer<R>.allocate(capacity: lhs.count)
    defer { outPointer.deallocate(capacity: lhs.count) }
    
    var p = outPointer
    for _ in 0..<rhs.count {
        p.pointee = handler(lhsPointer.pointee, rhsPointer.pointee)
        p += 1
        lhsPointer += 1
        rhsPointer += 1
    }
    
    return [R](UnsafeBufferPointer(start: outPointer, count: lhs.count))
}

#if os(iOS) || os(OSX)
    
    import Accelerate
    
    func applyVDspFunc<T>(_ arg: [T], _ vDspFunc: (UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> [T] {
        
        let out = UnsafeMutablePointer<T>.allocate(capacity: arg.count)
        defer { out.deallocate(capacity: arg.count) }
        
        vDspFunc(arg, 1,
                 out, 1, vDSP_Length(arg.count))
        
        return [T](UnsafeBufferPointer(start: out, count: arg.count))
    }
    
    func applyVDspFunc<T>(_ lhs: [T], _ rhs: T, _ vDspFunc: (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> [T] {
        
        let out = UnsafeMutablePointer<T>.allocate(capacity: lhs.count)
        defer { out.deallocate(capacity: lhs.count) }
        
        var rhs = rhs
        vDspFunc(lhs, 1,
                 &rhs,
                 out, 1, vDSP_Length(lhs.count))
        
        return [T](UnsafeBufferPointer(start: out, count: lhs.count))
    }
    
    func applyVDspFunc<T>(_ lhs: T, _ rhs: [T], _ vDspFunc: (UnsafePointer<T>, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> [T] {
        
        let out = UnsafeMutablePointer<T>.allocate(capacity: rhs.count)
        defer { out.deallocate(capacity: rhs.count) }
        
        var lhs = lhs
        vDspFunc(&lhs,
                 rhs, 1,
                 out, 1, vDSP_Length(rhs.count))
        
        return [T](UnsafeBufferPointer(start: out, count: rhs.count))
    }
    
    func applyVDspFunc<T>(_ lhs: [T], _ rhs: [T], _ vDspFunc: (UnsafePointer<T>, vDSP_Stride, UnsafePointer<T>, vDSP_Stride, UnsafeMutablePointer<T>, vDSP_Stride, vDSP_Length) -> Void) -> [T] {
        
        precondition(lhs.count == rhs.count, "Two NDArrays have incompatible shape.")
        
        let out = UnsafeMutablePointer<T>.allocate(capacity: lhs.count)
        defer { out.deallocate(capacity: lhs.count) }
        
        vDspFunc(lhs, 1,
                 rhs, 1,
                 out, 1,
                 vDSP_Length(lhs.count))
        
        return [T](UnsafeBufferPointer(start: out, count: lhs.count))
    }
    
#endif
