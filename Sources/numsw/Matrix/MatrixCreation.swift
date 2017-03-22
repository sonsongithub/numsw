

extension Matrix {
    public static func filled(with value: T, rows: Int, columns: Int) -> Matrix<T> {
        let elements = [T](repeating: value, count: rows*columns)
        return Matrix(rows: rows, columns: columns, elements: elements)
    }
}

extension Matrix where T: ZeroOne {
    public static func zeros(rows: Int, columns: Int) -> Matrix<T> {
        return Matrix.filled(with: T.zero, rows: rows, columns: columns)
    }
    
    public static func ones(rows: Int, columns: Int) -> Matrix<T> {
        return Matrix.filled(with: T.one, rows: rows, columns: columns)
    }
    
    /* return identity matrix */
    public static func eye(_ size: Int) -> Matrix<T> {
        var identity = zeros(rows: size, columns: size)
        (0..<size).forEach { identity[$0, $0] = T.one }
        return identity
    }
}

extension Matrix where T: Strideable {
    /* return row matrix 
     * first element is `from`
     * following elements are evenly spaced with `stride`, while it's smaller than `to`
     */
    public static func range(from: T, to: T, stride: T.Stride) -> Matrix<T> {
        let elements = Array(Swift.stride(from: from, to: to, by: stride))
        return Matrix(rows: 1, columns: elements.count, elements: elements)
    }
}

extension Matrix where T: FloatingPoint {
    /* return row matrix 
     * first element is `low`, last element is `high`
     * and internal elements are evenly spaced
     */
    public static func linspace(low: T, high: T, count: Int) -> Matrix<T> {
        let d = high - low
        let steps = T(count-1)
        let elements = (0..<count).map { low + T($0)*d/steps }
        return Matrix(rows: 1, columns: count, elements: elements)
    }
}
