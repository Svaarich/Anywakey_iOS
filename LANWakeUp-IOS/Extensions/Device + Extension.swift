import SwiftUI

extension Device {
    // Copy device info to clipboard
    func exportJSON() {
        let shareDevice: String = """
                                {
                                "name": "\(name)",
                                "MAC": "\(MAC)",
                                "BroadcastAddr": "\(BroadcastAddr)",
                                "Port": "\(Port)"
                                }
                                """
        UIPasteboard.general.string = shareDevice
    }
}
