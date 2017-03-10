

public struct NDArray<T> {
    private var _shape: [Int]
    public var shape: [Int] {
        get {
            return _shape
        }
        set {
            self = reshaped(newValue)
        }
    }
    
    public internal(set) var elements: [T]
    
    public init(shape: [Int], elements: [T]) {
        precondition(shape.reduce(1, *) == elements.count, "Shape and elements are not compatible.")
        self._shape = shape
        self.elements = elements
    }
}

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
}
