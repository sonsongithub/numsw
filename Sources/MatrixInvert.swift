
import Accelerate


extension Matrix where T: RealFloat {
    public func inverted() -> Matrix<Float> {
        var inMatrix:[Double] = self.elements.map { Double($0.value) }
        var N:__CLPK_integer        = __CLPK_integer( sqrt( Double( self.rows*self.columns ) ) )
        var pivots:[__CLPK_integer] = [__CLPK_integer](repeating: 0, count: Int(N))
        var workspace:[Double]      = [Double](repeating: 0.0, count: Int(N))
        var error: __CLPK_integer   = 0
        dgetrf_(&N, &N, &inMatrix, &N, &pivots, &error)
        dgetri_(&N, &inMatrix, &N, &pivots, &workspace, &N, &error)
        return Matrix<Float>(rows: self.rows, columns: self.columns, elements: inMatrix.map(Float.init))
    }
}

extension Matrix where T: RealDouble {
    public func inverted() -> Matrix<Double> {
        var inMatrix:[Double] = self.elements.map { $0.value }
        var N:__CLPK_integer        = __CLPK_integer( sqrt( Double( self.rows*self.columns ) ) )
        var pivots:[__CLPK_integer] = [__CLPK_integer](repeating: 0, count: Int(N))
        var workspace:[Double]      = [Double](repeating: 0.0, count: Int(N))
        var error: __CLPK_integer   = 0
        dgetrf_(&N, &N, &inMatrix, &N, &pivots, &error)
        dgetri_(&N, &inMatrix, &N, &pivots, &workspace, &N, &error)
        return Matrix<Double>(rows: self.rows, columns: self.columns, elements: inMatrix)
    }
}
