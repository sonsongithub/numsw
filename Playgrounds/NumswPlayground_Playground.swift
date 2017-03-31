//
//  NumswPlayground_Playground.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/05.
//  Copyright © 2017年 sonson. All rights reserved.
//

//  This file is not included for iOS app build target

#if os(iOS)
    #if SANDBOX_APP
        //  sandbox app
    #else
        //  playground
        import PlaygroundSupport
    #endif
#endif

public extension NumswPlayground {
    public static func initialize() {

        
        #if os(iOS)
            #if SANDBOX_APP
                //  sandbox app
                print("[NumswPlaygrounds.initialize] not in playground")
            #else
                //  playground
                let s = NumswPlayground.shared
                PlaygroundPage.current.liveView = s.viewController
            #endif
        #else
            print("[NumswPlaygrounds.initialize] not in iOS")
        #endif
    }
}

