
extension NDArray {
    public func reshaped(_ newShape: [Int]) -> NDArray<T> {
        
        precondition(newShape.filter({ $0 == -1 }).count <= 1, "Invalid shape.")
        
        var newShape = newShape
        if let autoIndex = newShape.index(of: -1) {
            let prod = -newShape.reduce(1, *)
            newShape[autoIndex] = elements.count / prod
        }
        
        return NDArray(shape: newShape, elements: self.elements)
    }
    
    public func raveled() -> NDArray<T> {
        return reshaped([-1])
    }
}
