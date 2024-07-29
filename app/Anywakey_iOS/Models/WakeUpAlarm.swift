
import Foundation

public struct WakeUpAlarm: Hashable, Identifiable {
    let device: Device
    let time: Date
    public let id: String = UUID().uuidString
    
    // boot computer using pre-configured alarm
    func boot() {
        _ = Network.instance.boot(device: device)
    }
}

