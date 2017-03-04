
import Accelerate

extension Matrix  {
    public func inverted() -> Matrix {
        var inMatrix:[Double] = self.elements
        var N:__CLPK_integer        = __CLPK_integer( sqrt( Double( self.rows*self.columns ) ) )
        var pivots:[__CLPK_integer] = [__CLPK_integer](repeating: 0, count: Int(N))
        var workspace:[Double]      = [Double](repeating: 0.0, count: Int(N))
        var error: __CLPK_integer   = 0
        dgetrf_(&N, &N, &inMatrix, &N, &pivots, &error)
        dgetri_(&N, &inMatrix, &N, &pivots, &workspace, &N, &error)
        return Matrix(rows: self.rows, columns: self.columns, elements: inMatrix)
    }
}
