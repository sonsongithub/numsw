
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

private func calculateIndex<T>(_ array: NDArray<T>, _ index: [Int]) -> Int {
    precondition(index.count == array.shape.count, "Invalid index.")
    
    // minus index
    var index = index
    for i in 0..<index.count {
        precondition(-array.shape[i] <= index[i] && index[i] < array.shape[i], "Invalid index.")
        if index[i] < 0 {
            index[i] += array.shape[i]
        }
    }
    
    // calculate
    let elementIndex = zip(index, Array(array.shape.dropFirst()) + [1]).reduce(0) { acc, x in
        return (acc + x.0) * x.1
    }
    
    return elementIndex
}


private func getElement<T>(_ array: NDArray<T>, _ index: [Int]) -> T {
    let elementIndex = calculateIndex(array, index)
    return array.elements[elementIndex]
}

private func setElement<T>(_ array: inout NDArray<T>, _ index: [Int], newValue: T) {
    let elementIndex = calculateIndex(array, index)
    array.elements[elementIndex] = newValue
}


private func calculateElementIndices(indices: [[Int]]) -> [[Int]] {
    guard indices.count > 0 else {
        return [[]]
    }
    let head = indices[0]
    let tail = Array(indices.dropFirst())
    let appended =  head.flatMap { h -> [[Int]] in
        calculateElementIndices(indices: tail).map { list in [h] + list }
    }
    return appended
}


private func formatIndices<T>(_ array: NDArray<T>, _ indices: [[Int]?]) -> [[Int]] {
    var padIndices = indices
    if padIndices.count < array.shape.count {
        padIndices = indices + [[Int]?](repeating: nil, count: array.shape.count - padIndices.count)
    }
    
    let indices = padIndices.enumerated().map { i, indexArray in
        indexArray ?? Array(0..<array.shape[i])
    }
    return indices
}


private func getSubarray<T>(_ array: NDArray<T>, _ indices: [[Int]?]) -> NDArray<T> {
    
    let indices = formatIndices(array, indices)
    
    let shape = indices.map { $0.count }
    let elements = calculateElementIndices(indices: indices).map { getElement(array, $0) }
    
    return NDArray(shape: shape, elements: elements)
}

private func setSubarray<T>(_ array: inout NDArray<T>, _ indices: [[Int]?], _ newValue: NDArray<T>) {
    let indices = formatIndices(array, indices)
    
    let shape = indices.map { $0.count }
    precondition(shape == newValue.shape, "Arguments are incompatible.")
    
    for (i, index) in calculateElementIndices(indices: indices).enumerated() {
        setElement(&array, index, newValue: newValue.elements[i])
    }
}

//private func getWithMaskArray<T>(_ array: NDArray<T>, _ mask: NDArray<Bool>) -> NDArray<T> {
//    precondition(array.shape.count >= mask.shape.count, "Mask array shape must be fewer.")
//    precondition(zip(array.shape, mask.shape).reduce(true){ $0 && $1.0 == $1.1 }, "Incompatible shape.")
//    
//}
