
import Foundation
import SystemConfiguration

public class Network {
    
    private init() {}
    
    static let instance = Network()
    
    private let wakeUp = WakeOnLAN()
    
    // Boot selected device
    func boot(device: Device) -> Error? {
        guard device.BroadcastAddr.isValidAdress(),
              device.MAC.isValidMAC(),
              device.Port.isValidPort()
        else { return nil }
        return wakeUp.target(device: device)
    }
    
    // Ping selected host / IP address and returns
    func ping(address: String, onDone: @escaping (_ ping: Double, _ isAccessible: Bool) -> Void) {
        // if address is empty returns false
        guard
            !address.isEmpty,
            address.contains(where: { $0 == "." } )
        else { return onDone(0, false) }
            let ones = try? SwiftyPing(host: address,
                                       configuration: PingConfiguration(interval: 0.5, with: 2),
                                       queue: DispatchQueue.global())
            ones?.observer = { responce in
                let isSuccess = responce.error == nil
                DispatchQueue.main.async {
                    onDone(responce.duration, isSuccess)
                }
            }
            ones?.targetCount = 1
            try? ones?.startPinging()
    }
    
    //
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

