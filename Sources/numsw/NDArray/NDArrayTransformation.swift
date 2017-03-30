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
        return NDArray(shape: [elements.count], elements: elements)
    }
}

extension NDArray {
    
    public func transposed() -> NDArray<T> {
        let axes: [Int] = (0..<shape.count).reversed()
        return transposed(axes)
    }
    
    public func transposed(_ axes: [Int]) -> NDArray<T> {
        
        precondition(axes.count == shape.count, "Number of `axes` and number of dimensions must correspond.")
        precondition(Set(axes) == Set(0..<shape.count), "Argument `axes` must contain each axis.")
        
        let outShape = axes.map { self.shape[$0] }
        
        let outPointer = UnsafeMutablePointer<T>.allocate(capacity: self.elements.count)
        defer { outPointer.deallocate(capacity: self.elements.count) }
        
        let inIndices = calculateIndices(formatIndicesInAxes(shape, []))
        
        for i in inIndices {
            let oIndex = calculateIndex(outShape, axes.map { i[$0] })
            outPointer.advanced(by: oIndex).pointee = getElement(self, i)
        }
        
        let elements = Array(UnsafeBufferPointer(start: outPointer, count: self.elements.count))
        return NDArray(shape: outShape, elements: elements)
    }
}
