
import SwiftUI

extension Double {
    func asPingString() -> String {
        let ping = String(format: "%.1f", self * 1000)
        return ping + " ms"
    }
}
