
import SwiftUI

class AnyWidgetData: ObservableObject {
    @Published var deviceList: [Device] = []
    
    init() {
       fetchPinnedDevices()
    }
    
    func fetchPinnedDevices() {
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            if let data = userDefaults.data(forKey: "devices") {
                do {
                    let decoder = JSONDecoder()
                    let savedDevices = try decoder.decode([Device].self, from: data)
                    let pinnedDevices = savedDevices.filter( { $0.isPinned } )
                    var devices: [Device] = []
                    if !pinnedDevices.isEmpty {
                        for index in 0..<pinnedDevices.count {
                            if index < 3 {
                                devices.append(pinnedDevices[index])
                            } else {
                                return
                            }
                        }
                    }
                    deviceList = devices
                } catch {
                    print("Unable to Decode devices (\(error))")
                }
            }
        }
    }
}

