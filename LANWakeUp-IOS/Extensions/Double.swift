import Foundation

extension Double {
    // Formates Double to string and return ping in mseconds
    func asPingString() -> String {
        let ping = String(format: "%.1f", self * 1000)
        return ping + " ms"
    }
}
