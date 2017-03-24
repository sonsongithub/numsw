import Foundation

extension NDArray {
    public static func stack(_ arrays: [NDArray<T>], axis: Int = 0) -> NDArray<T> {
        
        let shape = arrays.first!.shape
        
        var axis = axis
        if axis < 0 {
            axis += arrays.first!.shape.count + 1
        }
        
        precondition(0 <= axis && axis <= shape.count, "Invalid axis.")
        precondition(!arrays.contains { $0.shape != shape }, "All NDArrays must have same shape.")
        
        var newShape = shape
        newShape.insert(1, at: axis)
        
        return _concatenate(arrays.map { $0.reshaped(newShape) }, along: axis)
    }
    
    public static func concatenate(_ arrays: [NDArray<T>], along axis: Int = 0) -> NDArray<T> {
        var axis = axis
        if axis < 0 {
            axis += arrays.first!.shape.count
        }
        
        let shapeWithoutConcatAxis = arrays.first!.shape.removed(at: axis)
        precondition(0 <= axis && axis < arrays.first!.shape.count, "Invalid axis.")
        precondition(!arrays.contains { $0.shape.removed(at: axis) != shapeWithoutConcatAxis },
                     "All NDArrays must have same shape.")
        
        return _concatenate(arrays, along: axis)
    }
}

func _concatenate<T>(_ arrays: [NDArray<T>], along axis: Int) -> NDArray<T> {
    let shapeBeforeConcatAxis = [Int](arrays.first!.shape.prefix(upTo: axis))
    let shapeAfterConcatAxis = [Int](arrays.first!.shape.dropFirst(axis+1))
    
    let totalCount = arrays.map { $0.elements.count }.reduce(0, +)
    let concatAxisSize = arrays.map { $0.shape[axis] }.reduce(0, +)
    
    let out = UnsafeMutablePointer<T>.allocate(capacity: totalCount)
    defer { out.deallocate(capacity: totalCount) }
    
    let reshapedArrays = arrays.map { $0.reshaped([-1, $0.shape[axis]] + shapeAfterConcatAxis) }
    let copyCounts = reshapedArrays.map { $0.shape.dropFirst().reduce(1, *) }
    
    var pointer = out
    
    for i in 0..<reshapedArrays.first!.shape[0] {
        for (count, array) in zip(copyCounts, reshapedArrays) {
            let p = UnsafePointer(array.elements).advanced(by: i*count)
            memcpy(pointer, p, MemoryLayout<T>.size * count)
            pointer += count
        }
    }
    
    let elements = Array(UnsafeBufferPointer(start: out, count: totalCount))
    return NDArray(shape: shapeBeforeConcatAxis + [concatAxisSize] + shapeAfterConcatAxis,
                   elements: elements)
}
