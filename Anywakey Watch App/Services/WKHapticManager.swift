
import SwiftUI
import Foundation

struct WKHapticManager {
    
    private init() {}
    
    static let instance = WKHapticManager()
    
    func play(_ type: WKHapticType) {
        WKInterfaceDevice.current().play(type)
    }
}
