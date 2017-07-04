func apply<T, R>(_ arg: NDArray<T>, _ handler: (T) -> R) -> NDArray<R> {
    return NDArray(shape: arg.shape, elements: apply(arg.elements, handler))
}

func combine<T, U, R>(_ lhs: NDArray<T>, _ rhs: NDArray<U>, _ handler: (T, U) -> R) -> NDArray<R> {
    precondition(lhs.shape==rhs.shape, "Two NDArrays have incompatible shape.")
    return NDArray(shape: lhs.shape, elements: combine(lhs.elements, rhs.elements, handler))
}

// index calculation
func calculateIndex(_ shape: [Int], _ index: [Int]) -> Int {
    /* calculate index in elelemnts from index in NDArray
     *
     * example:
     * - arguments:
     *   + array.shape = [3, 4, 5]
     *   + index = [1, 2, 3]
     * - return:
     *   + ((3)*4+2)*5+3 = 73
     */
    
    precondition(index.count == shape.count, "Invalid index.")
    
    // minus index
    var index = index
    for i in 0..<index.count {
        precondition(-shape[i] <= index[i] && index[i] < shape[i], "Invalid index.")
        if index[i] < 0 {
            index[i] += shape[i]
        }
    }
    
    // calculate
    let elementIndex = zip(index, Array(shape.dropFirst()) + [1]).reduce(0) { acc, x in
        return (acc + x.0) * x.1
    }
    
    return elementIndex
}

func calculateIndices(_ indicesInAxes: [[Int]]) -> [[Int]] {
    /* calculate indices in NDArray from indices in axes
     * 
     * example:
     * - arguments:
     *   + array.shape = [3, 4, 5]
     *   + indices = [[1, 2], [2, 3], [3]]
     * - return:
     *   + [[1, 2, 3], [1, 3, 3], [2, 2, 3], [2, 3, 3]]
     */
    
    guard indicesInAxes.count > 0 else {
        return [[]]
    }
    let head = indicesInAxes[0]
    let tail = Array(indicesInAxes.dropFirst())
    let appended =  head.flatMap { h -> [[Int]] in
        calculateIndices(tail).map { list in [h] + list }
    }
    return appended
}

func formatIndicesInAxes(_ shape: [Int], _ indicesInAxes: [[Int]?]) -> [[Int]] {
    /* Format subarray's indices
     * - fulfill shortage
     * - nil turns into full indices
     *
     * example:
     * - arguments:
     *   + array.shape = [3, 4, 5]
     *   + indices = [[1, 2], [2, 3]]
     * - return:
     *   + [[1, 2], [2, 3], [0, 1, 2, 3, 4]]
     */
    var padIndices = indicesInAxes
    if padIndices.count < shape.count {
        padIndices = indicesInAxes + [[Int]?](repeating: nil, count: shape.count - padIndices.count)
    }
    
    let indices = padIndices.enumerated().map { (arg) -> [Int] in
        
        let (i, indexArray) = arg
        return indexArray ?? Array(0..<shape[i])
    }
    return indices
}

extension Array {
    func removed(at index: Int) -> Array {
        var array = self
        array.remove(at: index)
        return array
    }
    
    func replaced(with newElement: Element, at index: Int) -> Array {
        var array = self
        array[index] = newElement
        return array
    }
}
