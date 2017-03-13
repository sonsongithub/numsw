
import Foundation

func _uniform<T: FloatingPoint>(low: T = 0, high: T = 1) -> T {
    return (high-low)*(T(arc4random_uniform(UInt32.max)) / T(UInt32.max))+low
}
