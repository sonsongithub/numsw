//: Playground - noun: a place where people can play

NumswPlayground.initialize()

do {
    let t = Matrix.range(from: 0, to: 10, stride: 0.01)
    let siny = sin(t*64)
            
            
            
    addLine(x: t.elements, y: siny.elements)
}
do {
    let t = Matrix.range(from: 0.1, to: 10, stride: 0.01)
    let siny = log(t*1.5)
    addLine(x: t.elements, y: siny.elements)
}
do {
    let t = Matrix.range(from: -10, to: 10, stride: 0.01)
    let siny = tan(t*0.2)
    addLine(x: t.elements, y: siny.elements)
}
        
        
do {
    // create dummy data
    let x = Matrix(rows: 2, columns: 6, elements: [1, 2, 3, 4, 5, 6, 1, 1, 1, 1, 1, 1])
    let noise = Matrix.normal(rows: 1, columns: 6)
    let x1 = Matrix(rows: 1, columns: 6, elements: [1, 2, 3, 4, 5, 6])
            
    // data with noise
    let yn = 6 * x1 + 10 + noise
            
    // linear regression
    let xx = x * x.transposed()
    let a = xx.inverted()
    let b = x.transposed() * a
    let A = yn * b
            
    // data for presentation
    let x_p = Matrix.range(from: 0, to: 6, stride: 0.1)
    let y_p = A[0,0] * x_p + A[0,1]
            
    // rendering
    addLine2(x: x_p.elements, y: y_p.elements, x2: x.elements, y2: yn.elements)
}
        
do {
    let x = Matrix(rows: 2, columns: 6, elements: [1, 2, 5, 9, 13, 15, 1, 1, 1, 1, 1, 1])
    let y = Matrix(rows: 1, columns: 6, elements: [1, 2, 3, 5, 10, 50])
            
    let xx = x * x.transposed()
    x.transposed().show()
            
    let a = xx.inverted()
    let logy = log(y)
            
    let b = x.transposed() * a
    let A = logy * b
            
    let x_p = Matrix.range(from: 0, to: 45, stride: 0.1)
    let y_p = exp(A[0,0] * x_p + A[0,1])
            
    addLine2(x: x_p.elements, y: y_p.elements, x2: x.elements, y2: y.elements)
}
