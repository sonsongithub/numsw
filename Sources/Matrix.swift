public struct Matrix {
    
    var rows: Int
    var columns: Int
    
    var elements: [Double]
    
    public init(rows: Int, columns: Int, elements: [Double]) {
        self.rows = rows
        self.columns = columns
        self.elements = elements
    }
}

extension Matrix {
    public func reshaped(rows: Int, cols: Int) -> Matrix {
        assert(rows * columns == self.rows * self.columns, "Element count must be unchanged.")
        
        return Matrix(rows: rows, columns: columns, elements: self.elements)
    }
}
