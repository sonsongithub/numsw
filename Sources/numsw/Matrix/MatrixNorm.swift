import Foundation

public func frobeniusNorm<T: FloatingPoint>(_ hs: Matrix<T>) -> T {
    return hs.elements.reduce(0) { (result, value) in
        return result + value * value
    }
}

extension Matrix where T: FloatingPoint {
    public var frobeniusNorm: T {
        return self.elements.reduce(0) { (result, value)  in
            return result + value * value
        }
    }
}
