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
        var string = "\(aMatrix.rows)x\(aMatrix.columns)\n"
        
        for i in 0..<aMatrix.rows {
            let s: [String] = (0..<aMatrix.columns).map({ aMatrix.elements[i * aMatrix.columns + $0] }).flatMap({ String($0) })
            let r = s.joined(separator: ", ")
            string += "[ \(r) ]\n"
        }
        super.init(string)
    }
    
    private var compositer: CompositeRenderer?
}
