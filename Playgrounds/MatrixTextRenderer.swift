//
//  MatrixTextRenderer.swift
//  sandbox
//
//  Created by sonson on 2017/03/14.
//  Copyright © 2017年 sonson. All rights reserved.
//

import Foundation
import CoreGraphics

#if SANDBOX_APP
    import numsw
#endif

public class MatrixTextRenderer: TextRenderer {
    let matrix: Matrix<Double>
    
    public init(_ aMatrix: Matrix<Double>) {
        matrix = aMatrix
        super.init("")
    }
    
    private var compositer: CompositeRenderer?
}
