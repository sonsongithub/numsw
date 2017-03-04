struct Matrix<T> {
    
    var rows: Int
    var cols: Int
    
    var elements: [T]
    
    init(rows: Int, cols: Int, elements: [T]) {
        self.rows = rows
        self.cols = cols
        self.elements = elements
    }
}

extension Matrix {
    subscript(row: Int, column: Int) -> T {
        get {
            return elements[row*cols + column]
        }
        set {
            elements[row*cols+column] = newValue
        }
    }
    
    subscript(row: Int) -> Matrix<T> {
        get {
            return Matrix(rows: 1, cols: cols, elements: Array(elements[row*cols..<row*cols+cols]))
        }
        set {
            // TODO
        }
    }
}

extension Matrix {
    func reshaped(rows: Int, cols: Int) -> Matrix<T> {
        assert(rows*cols == self.rows*self.cols, "Element count must be unchanged.")
        
        return Matrix(rows: rows, cols: cols, elements: self.elements)
    }
}
