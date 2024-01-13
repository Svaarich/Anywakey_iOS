import Foundation

public struct Device: Hashable, Identifiable, Codable {
    
    init(name: String, MAC: String, BroadcastAddr: String, Port: String, isPinned: Bool = false, id: String = UUID().uuidString) {
        self.name = name
        self.MAC = MAC
        self.BroadcastAddr = BroadcastAddr
        self.Port = Port
        self.isPinned = isPinned
        self.id = id
    }
    
    let name: String
    let MAC: String
    let BroadcastAddr: String
    let Port: String
    let isPinned: Bool
    public var id = UUID().uuidString
    
    func pinToggle() -> Device {
        let updatedDevice = Device(name: name,
                                    MAC: MAC,
                                    BroadcastAddr: BroadcastAddr,
                                    Port: Port,
                                    isPinned: !isPinned)
        return updatedDevice
    }
}

