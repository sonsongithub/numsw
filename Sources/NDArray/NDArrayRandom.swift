
import Foundation

private func _uniform<T: FloatingPoint>(low: T = 0, high: T = 1) -> T {
    return (high-low)*(T(arc4random_uniform(UInt32.max)) / T(UInt32.max))+low
}

extension NDArray {
    
    public static func uniform<T: FloatingPointFunctions & FloatingPoint>(low: T = 0, high: T = 1, shape: [Int]) -> NDArray<T> {
        let count = shape.reduce(1, *)
        let elements = (0..<count).map { _ in _uniform(low: low, high: high) }
        
        return NDArray<T>(shape: shape, elements: elements)
    }
    
    public static func normal<T: FloatingPoint & FloatingPointFunctions & Arithmetic>(mu: T = 0, sigma: T = 0, shape: [Int]) -> NDArray<T> {
        let u1 = uniform(low: T(0), high: T(1), shape: shape)
        let u2 = uniform(low: T(0), high: T(1), shape: shape)
        
        let stdNormal =  sqrt(-2*log(u1)) * cos(2*T.pi*u2)
        
        return stdNormal*sigma + mu
    }
    
}
