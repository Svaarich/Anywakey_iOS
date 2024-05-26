
import SwiftUI

class AnyWidgetData: ObservableObject {
    @Published var deviceList: [Device] = []
    @Published var indexColor1: Int = 1
    @Published var indexColor2: Int = 1
    
    init() {
        fetchPinnedDevices()
        fetchColorIndecies()
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
    
    private func getDeviceIndex(tileNumber: Int) -> Int {
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            let key = "widgetDevice_" + "\(tileNumber)"
            let index = userDefaults.integer(forKey: key)
            return index
        }
        return 0
    }
    
    func fetchColorIndecies() {
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            indexColor1 = userDefaults.integer(forKey: "widgetColor_1")
            indexColor2 = userDefaults.integer(forKey: "widgetColor_2")
        }
        
    }
    
    func getWidgetMode() {
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            widgetMode = userDefaults.bool(forKey: "2widgetMode")
        }
    }
}

