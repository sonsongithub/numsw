import Foundation

extension Matrix where T: FloatingPointFunctions & FloatingPoint {
    
    public static func uniform(low: T = 0, high: T = 1, rows: Int, columns: Int) -> Matrix<T> {
        let count = rows * columns
        let elements = (0..<count).map { _ in _uniform(low: low, high: high) }
        
        return Matrix<T>(rows: rows,
                         columns: columns,
                         elements: elements)
    }
}

extension Matrix where T: FloatingPoint & FloatingPointFunctions & Arithmetic {
    
    public static func normal(mu: T = 0, sigma: T = 1, rows: Int, columns: Int) -> Matrix<T> {
        // Box-Muller's method
        let u1 = uniform(low: T(0), high: T(1), rows: rows, columns: columns)
        let u2 = uniform(low: T(0), high: T(1), rows: rows, columns: columns)
        
        let stdNormal =  sqrt(-2*log(u1)) .* cos(2*T.pi*u2)
        
        return stdNormal*sigma + mu
    }
}
