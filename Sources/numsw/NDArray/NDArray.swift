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
