//
//  CompositableRenderer.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/06.
//  Copyright © 2017年 sonson. All rights reserved.
//

//  its composite multiple renderer as one renderer

import CoreGraphics

public class CompositeRenderer: Renderer {
    public init() {
        
    }
    
    public var renderers: [Renderer] = []
    
    public func render(context: CGContext, windowSize: CGSize) {
        for renderer in renderers {
            renderer.render(context: context, windowSize: windowSize)
        }
    }
}
