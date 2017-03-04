//
//  LineGraphRenderer.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit
import GLKit

class LineGraphRenderer : Renderer {
    func render(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        
        let ctx = UIGraphicsGetCurrentContext()!

        ctx.setLineWidth(2.0)
        let color = UIColor.red.cgColor
        
        ctx.setStrokeColor(color)
        
        //3.パスを作成
        ctx.move(to: CGPoint(x: 50, y: 50))
        ctx.addLine(to: CGPoint(x: 250, y: 250))

        ctx.closePath()
        ctx.strokePath()
        
        let cgImage = ctx.makeImage()!
        return UIImage(cgImage: cgImage)
    }
}
