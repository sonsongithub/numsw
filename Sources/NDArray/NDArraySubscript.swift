
extension NDArray {
    public subscript(index: Int...) -> T {
        get {
            return getElement(self, index)
        }
        set {
            setElement(&self, index, newValue: newValue)
        }
    }
    
    public subscript(indices: [Int]?...) -> NDArray<T> {
        get {
            return getSubarray(self, indices)
        }
        set {
            setSubarray(&self, indices, newValue)
        }
    }
    
    public subscript(ranges: CountableRange<Int>?...) -> NDArray<T> {
        let indices = ranges.map { range in
            range.map { r in
                Array<Int>(r)
            }
        }
        return getSubarray(self, indices)
    }
    
    public subscript(ranges: CountableClosedRange<Int>?...) -> NDArray<T> {
        let indices = ranges.map { range in
            range.map { r in
                Array<Int>(r)
            }
        }
        return getSubarray(self, indices)
    }
}


func getElement<T>(_ array: NDArray<T>, _ index: [Int]) -> T {
    let elementIndex = calculateIndex(array.shape, index)
    return array.elements[elementIndex]
}

func setElement<T>(_ array: inout NDArray<T>, _ index: [Int], newValue: T) {
    let elementIndex = calculateIndex(array.shape, index)
    array.elements[elementIndex] = newValue
}


func getSubarray<T>(_ array: NDArray<T>, _ indices: [[Int]?]) -> NDArray<T> {
    
    let indices = formatIndicesInAxes(array.shape, indices)
    
    let shape = indices.map { $0.count }
    let elements = calculateIndices(indices).map { getElement(array, $0) }
    
    return NDArray(shape: shape, elements: elements)
}

func setSubarray<T>(_ array: inout NDArray<T>, _ indices: [[Int]?], _ newValue: NDArray<T>) {
    let indices = formatIndicesInAxes(array.shape, indices)
    
    let shape = indices.map { $0.count }
    precondition(shape == newValue.shape, "Arguments are incompatible.")
    
    for (i, index) in calculateIndices(indices).enumerated() {
        setElement(&array, index, newValue: newValue.elements[i])
    }
}

//private func getWithMaskArray<T>(_ array: NDArray<T>, _ mask: NDArray<Bool>) -> NDArray<T> {
//    precondition(array.shape.count >= mask.shape.count, "Mask array shape must be fewer.")
//    precondition(zip(array.shape, mask.shape).reduce(true){ $0 && $1.0 == $1.1 }, "Incompatible shape.")
//    
//}
