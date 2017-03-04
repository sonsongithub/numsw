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

extension Matrix {
    public func reshaped(rows: Int, cols: Int) -> Matrix<T> {
        assert(rows * columns == self.rows * self.columns, "Element count must be unchanged.")
        
        return Matrix(rows: rows, columns: columns, elements: self.elements)
    }
}
