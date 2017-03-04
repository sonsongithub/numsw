
import Foundation

func _uniform(low: Double = 0, high: Double = 1) -> Double {
    return (high-low)*(Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max))+low
}

func _normal(mu: Double = 0, sigma: Double = 1) -> Double {
    let u = (_uniform(), _uniform())
    let x = sqrt(-2*log(u.0)) * cos(2*M_PI*u.1)
    return sigma*x + mu
}

extension Matrix {
    public static func uniform(rows: Int, columns: Int, low: Double = 0, high: Double = 1) -> Matrix {
        return Matrix(rows: rows,
                      columns: columns,
                      elements: (0..<rows*columns).map { _ in _uniform(low: low, high: high) })
    }
    
    public static func normal(rows: Int, columns: Int, mu: Double = 0, sigma: Double = 1) -> Matrix {
        return Matrix(rows: rows,
                      columns: columns,
                      elements: (0..<rows*columns).map { _ in _normal(mu: mu, sigma: sigma) })
    }
}
