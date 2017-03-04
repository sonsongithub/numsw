
extension Matrix {
    public subscript(row: Int, column: Int) -> T {
        get {
            return elements[row * columns + column]
        }
        set {
            elements[row * columns + column] = newValue
        }
    }
    
    public subscript(row: Int) -> Matrix<T> {
        get {
            return Matrix(rows: 1, columns: columns, elements: Array(elements[row * columns..<row * columns + columns]))
        }
        set {
            precondition(newValue.rows == 1, "Matrix rows must be 1.")
            precondition(newValue.columns == self.columns, "Matrices must have same columns.")
            
            for c in 0..<self.columns {
                self[row, c] = newValue[0, c]
            }
        }
    }
}
