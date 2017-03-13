
import Foundation

public protocol FloatingPointFunctions {
    
    static func sqrt(_ arg: Self) -> Self
    
    static func exp(_ arg: Self) -> Self
    static func log(_ arg: Self) -> Self
    
    static func sin(_ arg: Self) -> Self
    static func cos(_ arg: Self) -> Self
    static func tan(_ arg: Self) -> Self
}

extension Float: FloatingPointFunctions {
    public static func sqrt(_ arg: Float) -> Float {
        return Foundation.sqrt(arg)
    }
    
    public static func exp(_ arg: Float) -> Float {
        return Foundation.exp(arg)
    }
    
    public static func log(_ arg: Float) -> Float {
        return Foundation.log(arg)
    }
    
    public static func sin(_ arg: Float) -> Float {
        return Foundation.sin(arg)
    }
    
    public static func cos(_ arg: Float) -> Float {
        return Foundation.cos(arg)
    }
    
    public static func tan(_ arg: Float) -> Float {
        return Foundation.tan(arg)
    }
}

extension Double: FloatingPointFunctions {
    public static func sqrt(_ arg: Double) -> Double {
        return Foundation.sqrt(arg)
    }
    
    public static func exp(_ arg: Double) -> Double {
        return Foundation.exp(arg)
    }
    
    public static func log(_ arg: Double) -> Double {
        return Foundation.log(arg)
    }
    
    public static func sin(_ arg: Double) -> Double {
        return Foundation.sin(arg)
    }
    
    public static func cos(_ arg: Double) -> Double {
        return Foundation.cos(arg)
    }
    
    public static func tan(_ arg: Double) -> Double {
        return Foundation.tan(arg)
    }
}
