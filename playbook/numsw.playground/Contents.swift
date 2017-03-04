
let x = Matrix(rows: 2, columns: 6, elements: [1, 2, 5, 9, 13, 15, 1, 1, 1, 1, 1, 1])
let y = Matrix(rows: 1, columns: 6, elements: [1, 2, 3, 5, 10, 50])

let xx = x * x.transposed()
x.transposed().show()

let a = xx.inverted()
let logy = log(y)

let b = x.transposed() * a

let A = logy * b

let x_p = Matrix.range(from: 0, to: 10, stride: 0.1)
let y_p = exp(A[0,0] * x_p + A[0,1])

