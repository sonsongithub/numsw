
enum InvertError: Error {
    case IrregalValue(argument: Int)
    case SingularMatrix
}

#if os(iOS) || os(OSX)

    import Accelerate
    
    extension Matrix where T: DoubleProtocol {
        public func inverted() throws -> Matrix<Double> {
            precondition(rows == columns, "Matrix is not square.")
            
            var inMatrix: [Double] = self.elements.map { $0.value }
            var N: __CLPK_integer        = __CLPK_integer( sqrt( Double( self.rows*self.columns ) ) )
            var pivots: [__CLPK_integer] = [__CLPK_integer](repeating: 0, count: Int(N))
            var workspace: [Double]      = [Double](repeating: 0.0, count: Int(N))
            var error: __CLPK_integer   = 0
            dgetrf_(&N, &N, &inMatrix, &N, &pivots, &error)
            if error < 0 {
                throw InvertError.IrregalValue(argument: -Int(error))
            } else if error > 0 {
                throw InvertError.SingularMatrix
            }
            dgetri_(&N, &inMatrix, &N, &pivots, &workspace, &N, &error)
            if error < 0 {
                throw InvertError.IrregalValue(argument: -Int(error))
            } else if error > 0 {
                throw InvertError.SingularMatrix
            }

            return Matrix<Double>(rows: rows,
                                  columns: columns,
                                  elements: inMatrix)
            
        }
    }
    
    extension Matrix where T: FloatProtocol {
        public func inverted() throws -> Matrix<Float> {
            precondition(rows == columns, "Matrix is not square.")
            
            var inMatrix: [Float] = self.elements.map { $0.value }
            var N: __CLPK_integer        = __CLPK_integer( sqrt( Double( self.rows*self.columns ) ) )
            var pivots: [__CLPK_integer] = [__CLPK_integer](repeating: 0, count: Int(N))
            var workspace: [Float]      = [Float](repeating: 0.0, count: Int(N))
            var error: __CLPK_integer   = 0
            sgetrf_(&N, &N, &inMatrix, &N, &pivots, &error)
            if error < 0 {
                throw InvertError.IrregalValue(argument: -Int(error))
            } else if error > 0 {
                throw InvertError.SingularMatrix
            }
            sgetri_(&N, &inMatrix, &N, &pivots, &workspace, &N, &error)
            if error < 0 {
                throw InvertError.IrregalValue(argument: -Int(error))
            } else if error > 0 {
                throw InvertError.SingularMatrix
            }
            
            return Matrix<Float>(rows: rows,
                                 columns: columns,
                                 elements: inMatrix)
            
        }
    }
    
#endif
