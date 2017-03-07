//
//  NumswPlayground_Playground.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/05.
//  Copyright © 2017年 sonson. All rights reserved.
//

//  This file is not included for iOS app build target

import PlaygroundSupport

public extension NumswPlayground {
    public static func initialize() {
        let s = NumswPlayground.shared
        PlaygroundPage.current.liveView = s.viewController
    }
}
