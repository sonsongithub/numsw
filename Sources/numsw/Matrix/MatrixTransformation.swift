
extension Matrix {
    public func reshaped(rows: Int, cols: Int) -> Matrix<T> {
        assert(rows * columns == self.rows * self.columns, "Element count must be unchanged.")
        
        return Matrix(rows: rows, columns: columns, elements: self.elements)
    }
}
