import Foundation

class Computer: ObservableObject {
    
    init() {
        fetchUserDefaults()
    }
    
    @Published var listOfDevices: Array<Device> = []
    
    private var wakeUp = WakeUp()
    private var dataModel = DataModel()
    
    func boot(device: Device) -> Error? {
        Network.boot(device: device)
    }
    
    func fetchUserDefaults() {
        listOfDevices = dataModel.fetchUserDefaults()
    }
    
    func saveUserDefaults() {
        dataModel.saveUserDefaults(data: listOfDevices)
    }
    
    func delete(oldDevice: Device) {
        listOfDevices = dataModel.delete(device: oldDevice, data: listOfDevices)
    }
    
    func add(newDevice: Device) {
        listOfDevices = dataModel.add(newDevice: newDevice, data: listOfDevices)
    }
    
    func pinToggle(device: Device) {
        if let index = listOfDevices.firstIndex(where: { $0 == device } ) {
            listOfDevices[index] = device.pinToggle()
        }
    }
    func updateDevice(oldDevice: Device, newDevice: Device) {
        if let index = listOfDevices.firstIndex(where: { $0 == oldDevice } ) {
            listOfDevices[index] = newDevice
            saveUserDefaults()
        }
    }
}


