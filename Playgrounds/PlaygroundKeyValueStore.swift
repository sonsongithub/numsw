//
//  PlaygroundKeyValueStore.swift
//  sandbox
//
//  Created by Yusuke Ito on 4/16/17.
//  Copyright © 2017 sonson. All rights reserved.
//

// PlaygroundKeyValueStore as UserDefautls for sandbox app

#if os(iOS)
import Foundation

#if SANDBOX_APP
    //  sandbox app
    internal enum PlaygroundValue {
        case array([PlaygroundValue])
        case boolean(Bool)
        case data(Data)
        case date(Date)
        case dictionary([String: PlaygroundValue])
        case floatingPoint(Double)
        case integer(Int)
        case string(String)
    }
    internal class PlaygroundKeyValueStore {
        static let current = PlaygroundKeyValueStore()
        private init() {
            
        }
        subscript(key: String) -> PlaygroundValue? {
            set {
                print("KeyValueStore setting \(newValue as Any) for \(key)")
                if let value = newValue {
                    switch value {
                    case .floatingPoint(let double):
                        UserDefaults.standard.set(double, forKey: key)
                    case .integer(let integer):
                        UserDefaults.standard.set(integer, forKey: key)
                    default:
                        fatalError("Not implemented")
                    }
                } else {
                    UserDefaults.standard.removeObject(forKey: key)
                }
            }
            get {
                print("KeyValueStore getting for \(key)")
                guard let object = UserDefaults.standard.object(forKey: key) else {
                    return nil
                }
                if let integer = object as? Int {
                    return .integer(integer)
                } else if let double = object as? Double {
                    return .floatingPoint(double)
                } else {
                    fatalError("Not implemented")
                }
            }
        }
    }
#else
    //  playground
#endif

#endif
