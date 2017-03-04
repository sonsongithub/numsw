
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
            // TODO
        }
    }
}
