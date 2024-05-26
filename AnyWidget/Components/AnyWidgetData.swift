
import SwiftUI

class AnyWidgetData: ObservableObject {
    
    @Published var deviceList: [Device] = []
    @Published var indexColor1: Int = 1
    @Published var indexColor2: Int = 1
    @Published var widgetMode: Bool = false
    
    init() {
        fetchPinnedDevices()
        fetchColorIndecies()
        getWidgetMode()
    }
    
    func fetchPinnedDevices() {
        deviceList = []
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            if let data = userDefaults.data(forKey: "devices") {
                do {
                    let decoder = JSONDecoder()
                    let savedDevices = try decoder.decode([Device].self, from: data)
                    if !savedDevices.isEmpty {
                        deviceList.append(savedDevices[getDeviceIndex(tileNumber: 1)])
                        deviceList.append(savedDevices[getDeviceIndex(tileNumber: 2)])
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

