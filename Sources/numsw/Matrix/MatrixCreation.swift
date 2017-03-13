
extension Matrix {
    public static func zeros(rows: Int, columns: Int) -> Matrix {
        let count = columns * rows
        let cElements = UnsafeMutablePointer<Double>.allocate(capacity: count)
        defer { cElements.deallocate(capacity: count) }
        for i in 0..<count {
            cElements[i] = Double(0)
        }
        return Matrix(rows: rows, columns: columns, elements: Array(UnsafeBufferPointer(start: cElements, count: count)))
    }
    
    public static func ones(rows: Int, columns: Int) -> Matrix {
        let count = columns * rows
        let cElements = UnsafeMutablePointer<Double>.allocate(capacity: count)
        defer { cElements.deallocate(capacity: count) }
        for i in 0..<count {
            cElements[i] = Double(1)
        }
        return Matrix(rows: rows, columns: columns, elements: Array(UnsafeBufferPointer(start: cElements, count: count)))
    }
    
    public static func eye(size: Int) -> Matrix {
        var matrix = Matrix.zeros(rows: size, columns: size)
        for i in 0..<size {
            matrix.elements[i + i * matrix.columns] = 1
        }
        return matrix
    }
}
