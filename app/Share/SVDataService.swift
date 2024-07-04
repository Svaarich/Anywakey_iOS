
import Foundation

class SVDataService: ObservableObject {
    
    @Published var devices: [Device] = []
    @Published var devicesForImport: [Device] = []
    
    
    // Pin all divices to display selected
    private func preparedForDisplay(list: [Device]) -> [Device] {
        var list: [Device] = []
        for device in devices {
            if device.isPinned {
                list.append(device)
            } else {
                list.append(device.pinToggle())
            }
        }
        return list
    }
    
    // Extract from file
    func extractDevices(_ extensionContext: NSExtensionContext?, _ itemProviders: [NSItemProvider]) {
        guard devices.isEmpty else { return }
        DispatchQueue.global(qos: .userInteractive).async {
            for provider in itemProviders {
                let _ = provider.loadDataRepresentation(for: .text) { data, error in
                    let decoder = JSONDecoder()
                    do {
                        self.devices = try decoder.decode([Device].self, from: data!)
                        self.devicesForImport = self.devices
                        self.devices = self.preparedForDisplay(list: self.devices)
                    } catch {
                        print("Unable to read data. \(error)")
                    }
                }
            }
        }
    }
    
    // Get list of saved devices from UserDefaults
    private func getSavedDevices() -> [Device] {
        var savedDevices: [Device] = []
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            if let data = userDefaults.data(forKey: "devices") {
                do {
                    let decoder = JSONDecoder()
                    savedDevices = try decoder.decode([Device].self, from: data)
                } catch {
                    print("Unable to Decode devices (\(error))")
                }
            }
        }
        return savedDevices
    }
    
    // Save list with devices into UserDefaults
    func saveUserDefaults() {
        var list: [Device] = getSavedDevices()
        for index in 0..<devices.count {
            if devices[index].isPinned {
                list.append(devicesForImport[index])
            }
        }
        let data = list
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            do {
                let encoder = JSONEncoder()
                let savedDevices = try encoder.encode(data)
                userDefaults.set(savedDevices, forKey: "devices")
            } catch {
                print("Unable to Encode Array of devices (\(error))")
            }
        }
    }
}
