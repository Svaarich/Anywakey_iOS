
import Foundation
import SystemConfiguration

public class Network {
    
    //
    static func boot(device: Device) -> Error? {
        WakeUp().target(device: device)
    }
    
    //
    static func ping(address: String, onDone: @escaping (_ ping: Double, _ isAccessible: Bool) -> Void) {
        // if adress is empty returns false
        if !address.isEmpty {
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
        } else {
            onDone(0, false)
        }
    }
    
    //
    static func isConnectedToNetwork() -> Bool {
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

