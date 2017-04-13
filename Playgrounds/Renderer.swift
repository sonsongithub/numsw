//
//  Renderer.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import CoreGraphics
#if os(iOS)
    import UIKit
#endif

public protocol Renderer {
    func render(context: CGContext, windowSize: CGSize)
    var parentViewSize: CGSize { get set }
    var height: CGFloat { get }
#if os(iOS)
    var cellIdentifier: String { get }
#endif
}

#if os(iOS)
public extension Renderer {
    func renderToImage(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()!
        
        render(context: context, windowSize: size)
        
        let cgImage = context.makeImage()!
        
        return UIImage(cgImage: cgImage)
    }
    
    var cellIdentifier: String {
        return "RenderTableViewCell"
    }
}
#endif
