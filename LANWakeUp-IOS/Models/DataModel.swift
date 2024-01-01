
import Foundation

public class DataModel {
    
    // Get list of saved devices from UserDefaults
    func fetchUserDefaults() -> [Device] {
        if let data = UserDefaults.standard.data(forKey: "devices") {
            do {
                let decoder = JSONDecoder()
                let savedDevices = try decoder.decode([Device].self, from: data)
                return savedDevices
            } catch {
                print("Unable to Decode devices (\(error))")
            }
        }
        return []
    }
    
    // Save list with devices into UserDefaults
    func saveUserDefaults(data: [Device]) {
        let savedDevices = data
        do {
            let encoder = JSONEncoder()
            let defaults = UserDefaults.standard
            let savedDevices = try encoder.encode(savedDevices)
            defaults.set(savedDevices, forKey: "devices")
        } catch {
            print("Unable to Encode Array of devices (\(error))")
        }
    }
    
    // Delete device from array and return updated
    func delete(device: Device, data: [Device]) -> [Device] {
        var savedDevices = data
        for index in 0..<savedDevices.count {
            if device == savedDevices[index] {
                savedDevices.remove(at: index)
                saveUserDefaults(data: savedDevices)
                return savedDevices
            }
        }
        return savedDevices
    }
    
    // Add device to array and return updated
    func add(newDevice: Device, data: [Device]) -> [Device] {
        var savedDevices = data
        if data.isEmpty {
            return [newDevice]
        } else {
            savedDevices.append(newDevice)
            saveUserDefaults(data: savedDevices)
        }
        return savedDevices
    }
}
