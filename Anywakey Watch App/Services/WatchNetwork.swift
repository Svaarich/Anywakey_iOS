
import Foundation

struct WatchNetwork {
    
    private init () {}
    
    static let instance = WatchNetwork()
    
    private let wakeUp = WakeOnLAN()
    
    // Boot selected device
    func boot(device: Device) -> Error? {
        guard device.BroadcastAddr.isValidAdress(),
              device.MAC.isValidMAC(),
              device.Port.isValidPort()
        else { return nil }
        return wakeUp.target(device: device)
    }
    
}
