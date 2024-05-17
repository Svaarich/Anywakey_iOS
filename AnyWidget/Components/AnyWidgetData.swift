
import SwiftUI

class AnyWidgetData: ObservableObject {
    @Published var deviceList: [Device] = []
    
    init() {
       fetchPinnedDevices()
    }
    
    func fetchPinnedDevices() {
        deviceList = []
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            if let data = userDefaults.data(forKey: "devices") {
                do {
                    let decoder = JSONDecoder()
                    let savedDevices = try decoder.decode([Device].self, from: data)
                    let pinnedDevices = savedDevices.filter( { $0.isPinned } )
                    guard !pinnedDevices.isEmpty else { return }
                    if pinnedDevices.count <= 3 {
                        deviceList = pinnedDevices
                    } else {
                        for index in 0..<3 {
                            deviceList.append(pinnedDevices[index])
                        }
                    }
                } catch {
                    print("Unable to Decode devices (\(error))")
                }
            }
        }
    }
}

