import SwiftUI

extension Device {
    // Copy device info to clipboard
    func copyToShare() {
        let shareDevice: String = "Name: \(self.name)\nIP: \(self.BroadcastAddr)\nMAC: \(self.MAC)\nPort: \(Port)"
        UIPasteboard.general.string = shareDevice
        print(shareDevice)
    }
}
