//
//  TextRenderer.swift
//  sandbox
//
//  Created by sonson on 2017/04/07.
//  Copyright © 2017年 sonson. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

#if SANDBOX_APP
    import numsw
#endif

public class TextRenderer: Renderer {
    let string: String
    let attributedString: NSAttributedString
    
    public init(_ aString: String) {
        string = aString
        let font = UIFont.systemFont(ofSize: 14)
        attributedString = NSAttributedString(string: string, attributes: [NSFontAttributeName: font])
    }
    
    public var parentViewSize = CGSize.zero {
        didSet {
        }
    }
    
    public var height: CGFloat {
        return parentViewSize.height * 2.5
    }
    
    public func update() {
    }
    
    public func render(context: CGContext, windowSize: CGSize) {
    }
    
    private var compositer: CompositeRenderer?
}
