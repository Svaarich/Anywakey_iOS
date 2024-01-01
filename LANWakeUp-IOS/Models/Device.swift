
import Foundation

public struct Device: Hashable, Identifiable, Codable {
    
    var name: String
    var MAC: String
    var BroadcastAddr: String
    var Port: String
    var isPinned: Bool = false
    public var id = UUID().uuidString

}

