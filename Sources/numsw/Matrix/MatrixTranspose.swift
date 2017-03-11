extension Matrix {
    public func transposed() -> Matrix {
        let newElements = UnsafeMutablePointer<Double>.allocate(capacity: rows*columns)
        defer { newElements.deallocate(capacity: rows*columns) }
        for r in 0..<rows {
            for c in 0..<columns {
                newElements[c*rows+r] = elements[r*columns+c]
            }
        }
        return Matrix(rows: columns,
                      columns: rows,
                      elements: Array(UnsafeBufferPointer(start: newElements, count: rows*columns)))
    }
}
