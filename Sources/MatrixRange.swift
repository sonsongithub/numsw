
extension Matrix {
    public static func range(from: Int, to: Int, stride: Int) -> Matrix {
        
        let elements = Swift.stride(from: from, to: to, by: stride).map(Double.init)
        return Matrix(rows: elements.count,
                      columns: 1,
                      elements: elements)
    }
    
    public static func linspace(from: Double, to: Double, count: Int) -> Matrix {
        precondition(count > 0, "count must be larger than 0")
        let elements = (0..<count).map { i -> Double in
            from + Double(i)*(to-from)/Double(count-1)
        }
        return Matrix(rows: count,
                      columns: 1,
                      elements: elements)
    }
}
