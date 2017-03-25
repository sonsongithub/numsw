//
//  Dummydata.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import CoreGraphics

#if SANDBOX_APP
    import numsw
#endif

public struct DummyData {
    public static func points1() -> [CGPoint] {
        return [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 2, y: 4),
            CGPoint(x: 3, y: 9),
            CGPoint(x: 4, y: 16)
        ]
    }
    
    public static func points2() -> [CGPoint] {
        return [
            CGPoint(x: 0, y: 6),
            CGPoint(x: 2, y: 2),
            CGPoint(x: 4, y: 3)
        ]
    }
    
    public static func runTestScenario() {
        do {
            let t = Matrix<Double>.range(from: 0, to: 10, stride: 0.01)
            let siny = sin(t*64)
            
            addLine(x: t.elements, y: siny.elements)
        }
        do {
            let t = Matrix<Double>.range(from: 0.1, to: 10, stride: 0.01)
            let siny = log(t*1.5)
            addLine(x: t.elements, y: siny.elements)
        }
        do {
            let t = Matrix<Double>.range(from: -10, to: 10, stride: 0.01)
            let siny = tan(t*0.2)
            addLine(x: t.elements, y: siny.elements)
        }
        
        do {
            // create dummy data
            let x = Matrix<Double>(rows: 2, columns: 6, elements: [1, 2, 3, 4, 5, 6, 1, 1, 1, 1, 1, 1])
            let noise = Matrix<Double>.normal(rows: 1, columns: 6)
            let x1 = Matrix<Double>(rows: 1, columns: 6, elements: [1, 2, 3, 4, 5, 6])
            
            // data with noise
            let yn = 6 * x1 + 10 + noise
            
            // linear regression
            let xx = x * x.transposed()
            let a = try! xx.inverted()
            let b = x.transposed() * a
            let A = yn * b
            
            // data for presentation
            let x_p = Matrix.range(from: 0, to: 6, stride: 0.1)
            let y_p = A[0, 0] * x_p + A[0, 1]
            
            // rendering
            addLine2(x: x_p.elements, y: y_p.elements, x2: x.elements, y2: yn.elements)
        }
        
        do {
            let x = Matrix<Double>(rows: 2, columns: 6, elements: [1, 2, 5, 9, 13, 15, 1, 1, 1, 1, 1, 1])
            let y = Matrix<Double>(rows: 1, columns: 6, elements: [1, 2, 3, 5, 10, 50])
            
            let xx = x * x.transposed()
            x.transposed().show()
            
            let a = try! xx.inverted()
            let logy = log(y)
            
            let b = x.transposed() * a
            let A = logy * b
            
            let x_p = Matrix.range(from: 0, to: 45, stride: 0.1)
            let y_p = exp(A[0, 0] * x_p + A[0, 1])
            
            addLine2(x: x_p.elements, y: y_p.elements, x2: x.elements, y2: y.elements)
        }

    }
    
    public static func runHoldExample() {
        
        let t1 = Matrix.range(from: 0, to: 10, stride: 0.01)
        let siny1 = sin(t1 * 2)
        
        let t2 = Matrix.range(from: 0, to: 10, stride: 0.4)
        let siny2 = sin(t2 * 2)
        
        hold {
            plot(t1.elements, siny1.elements)
            scatter(t2.elements, siny2.elements)
        }
    }
}
