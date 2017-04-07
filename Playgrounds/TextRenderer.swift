//
//  TextRenderer.swift
//  sandbox
//
//  Created by sonson on 2017/04/07.
//  Copyright © 2017年 sonson. All rights reserved.
//

import Foundation
import CoreGraphics

#if SANDBOX_APP
    import numsw
#endif

public class TextRenderer: Renderer {
    let string: String
    
    public init(_ aString: String) {
        string = aString
    }
    
    public var parentViewSize = CGSize.zero
    
    public var height: CGFloat {
        return parentViewSize.height * 2.5
    }
    
    public func update() {
    }
    
    public func render(context: CGContext, windowSize: CGSize) {
    }
    
    private var compositer: CompositeRenderer?
}
