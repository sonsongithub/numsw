public struct Matrix<T> {
    
    var rows: Int
    var columns: Int
    
    var elements: [T]
    
    public init(rows: Int, columns: Int, elements: [T]) {
        self.rows = rows
        self.columns = columns
        self.elements = elements
    }
}

extension Matrix {
    public func reshaped(rows: Int, cols: Int) -> Matrix<T> {
        assert(rows * columns == self.rows * self.columns, "Element count must be unchanged.")
        
        return Matrix(rows: rows, columns: columns, elements: self.elements)
    }
}
