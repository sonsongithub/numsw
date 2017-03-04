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
        
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.move(to: CGPoint(x: 0, y: 0))
        ctx.addLine(to: CGPoint(x: size.width, y: size.height))
        ctx.closePath()
        ctx.strokePath()
        
        ctx.setStrokeColor(UIColor.green.cgColor)
        ctx.move(to: CGPoint(x: size.width, y: 0))
        ctx.addLine(to: CGPoint(x: 0, y: size.height))
        ctx.closePath()
        ctx.strokePath()

        let cgImage = ctx.makeImage()!
        return UIImage(cgImage: cgImage)
    }
}
