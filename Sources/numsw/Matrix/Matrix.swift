public struct Matrix<T> {
    
    public var rows: Int
    public var columns: Int
    public var count: Int {
        return columns * rows
    }
    
    public internal(set) var elements: [T]
    
    public init(rows: Int, columns: Int, elements: [T]) {
        precondition(rows*columns == elements.count, "`elements.count` must correspond to `rows*columns`")
        self.rows = rows
        self.columns = columns
        self.elements = elements
    }
    
    public init(_ elements: [[T]]) {
        let rows = elements.count
        precondition(rows > 0, "Matrix must have elements.")
        let columns = elements[0].count
        let elements = elements.flatMap { $0 }
        precondition(elements.count == rows*columns, "All rows must have same size.")
        self.init(rows: rows, columns: columns, elements: elements)
    }
    
    public func show() {
        var string = ""
        for i in 0..<rows {
            for j in 0..<columns {
                string.append("\(elements[j + i * columns]) ")
            }
            if i < rows - 1 {
                string.append("\n")
            }
        }
        print(string)
    }
}
