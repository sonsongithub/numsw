enum InvertError: Error {
    case IrregalValue(argument: Int)
    case SingularMatrix
}

#if os(iOS) || os(OSX)

    import Accelerate
    
    extension Matrix where T == Double {
        public func inverted() throws -> Matrix<Double> {
            precondition(rows == columns, "Matrix is not square.")
            
            var inMatrix: [Double] = self.elements
            var N: __CLPK_integer        = __CLPK_integer( sqrt( Double( self.rows*self.columns ) ) )
            var pivots: [__CLPK_integer] = [__CLPK_integer](repeating: 0, count: Int(N))
            var workspace: [Double]      = [Double](repeating: 0.0, count: Int(N))
            var error: __CLPK_integer   = 0
            
            var N1 = N
            var N2 = N
            
            // LU decomposition
            dgetrf_(&N, &N1, &inMatrix, &N2, &pivots, &error)
            if error < 0 {
                throw InvertError.IrregalValue(argument: -Int(error))
            } else if error > 0 {
                throw InvertError.SingularMatrix
            }
            
            N1 = N
            N2 = N
            
            // solve
            dgetri_(&N, &inMatrix, &N1, &pivots, &workspace, &N2, &error)
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
    
    extension Matrix where T == Float {
        public func inverted() throws -> Matrix<Float> {
            precondition(rows == columns, "Matrix is not square.")
            
            var inMatrix: [Float] = self.elements
            var N: __CLPK_integer        = __CLPK_integer( sqrt( Double( self.rows*self.columns ) ) )
            var pivots: [__CLPK_integer] = [__CLPK_integer](repeating: 0, count: Int(N))
            var workspace: [Float]      = [Float](repeating: 0.0, count: Int(N))
            var error: __CLPK_integer   = 0
            
            var N1 = N
            var N2 = N
            
            // LU decomposition
            sgetrf_(&N, &N1, &inMatrix, &N2, &pivots, &error)
            if error < 0 {
                throw InvertError.IrregalValue(argument: -Int(error))
            } else if error > 0 {
                throw InvertError.SingularMatrix
            }
            
            N1 = N
            N2 = N
            
            // solve
            sgetri_(&N, &inMatrix, &N1, &pivots, &workspace, &N2, &error)
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
