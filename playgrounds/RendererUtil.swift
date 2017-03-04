//
//  RendererUtil.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import CoreGraphics

public func toRadian(_ x: CGFloat) -> CGFloat {
    return x * CGFloat.pi / CGFloat(180.0)
}

public func toDegree(_ x: CGFloat) -> CGFloat {
    return x * CGFloat(180.0) / CGFloat.pi
}

public func computeViewportTransform(
    from: CGRect,
    to: CGRect,
    flipY: Bool) -> CGAffineTransform
{
    let fw = from.width
    let fh = from.height
    let tw = to.width
    let th = to.height
    
    var trans = CGAffineTransform.identity

    trans = trans.translatedBy(x: to.origin.x, y: to.origin.y)
    trans = trans.translatedBy(x: (tw / 2.0), y: (th / 2.0))
    
    let sx = tw / fw
    var sy = th / fh
    if flipY {
        sy *= -1
    }
    
    trans = trans.scaledBy(x: sx, y: sy)
    trans = trans.translatedBy(x: -(fw / 2.0), y: -(fh / 2.0))
    trans = trans.translatedBy(x: -from.origin.x, y: -from.origin.y)
    return trans
}

public func computeTickValues(
    min: CGFloat,
    max: CGFloat,
    step: CGFloat) -> [CGFloat]
{
    let x0 = Int(floor(min / step))
    let x1 = Int(ceil(max / step))
    
    var ret: [CGFloat] = []
    for xi in x0...x1 {
        let x = CGFloat(xi) * step
        ret.append(x)
    }
    
    return ret
}
