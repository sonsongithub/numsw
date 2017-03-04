//
//  RendererUtil.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import CoreGraphics

func toRadian(_ x: CGFloat) -> CGFloat {
    return x * CGFloat.pi / CGFloat(180.0)
}

func toDegree(_ x: CGFloat) -> CGFloat {
    return x * CGFloat(180.0) / CGFloat.pi
}

func computeViewportTransform(
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
    trans = trans.scaledBy(x: tw / fw, y: -(th / fh))
    trans = trans.translatedBy(x: -(fw / 2.0), y: -(fh / 2.0))
    trans = trans.translatedBy(x: -from.origin.x, y: -from.origin.y)
    return trans
}
