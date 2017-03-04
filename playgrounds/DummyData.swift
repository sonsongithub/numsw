//
//  Dummydata.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit

struct DummyData {
    static func points1() -> [CGPoint] {
        return [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 2, y: 4),
            CGPoint(x: 3, y: 9),
            CGPoint(x: 4, y: 16)
        ]
    }
    
    static func points2() -> [CGPoint] {
        return [
            CGPoint(x: 0, y: 6),
            CGPoint(x: 2, y: 2),
            CGPoint(x: 4, y: 3)
        ]
    }
}
