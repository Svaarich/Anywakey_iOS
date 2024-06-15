
import WatchConnectivity

final class WatchConnector: NSObject {
    
    var session: WCSession
    
    @Published var dataService: DeviceDataService {
        didSet {
            self.sendMessageData()
            self.sendStatusList()
        }
    }
    
    init(session: WCSession  = .default, dataService: DeviceDataService) {
        self.session = session
        self.dataService = dataService
        super.init()
        self.session.delegate = self
        session.activate()
    }
}

extension WatchConnector: WCSessionDelegate {
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        let decoder = JSONDecoder()
        let data = messageData
        do {
            let device = try decoder.decode(Device.self, from: data)
            print("Device to boot received: \(device.name)")
            _ = Network.instance.boot(device: device)
        } catch {
            print("Error parsing watch message: \(error)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Received message on iPhone: \(message)")
        if let action = message["action"] as? String {
            switch action {
            case "sendDevices":
                sendMessageData()
            case "updateStatus":
                sendStatusList()
            default:
                ()
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Error WCSession activation: \(error)")
        } else {
            print("The session has completed activation.")
        }
    }
    
    func prepareStatusMessage(list: [String : Bool]) {
        let message = ["status" : list]
        if session.isReachable {
            self.session.sendMessage(message, replyHandler: nil) { error in
                print("Error sending status list: \(error)")
            }
        }
    }
    
    // ping all devices in the list
    private func sendStatusList() {
        var statusList: [String : Bool] = [ : ]
        for device in dataService.allDevices {
            Network.instance.ping(address: device.BroadcastAddr) { ping, isAccessible in
                statusList[device.BroadcastAddr] = isAccessible
                self.prepareStatusMessage(list: statusList)
                print(statusList.debugDescription)
            }
        }
    }
    
    // send devices data to apple watch
    func sendMessageData() {
        guard let data = try? JSONEncoder().encode(getDevices()) else {
            return
        }
        if WCSession.isSupported() {
            self.session.sendMessageData(data, replyHandler: nil) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func getDevices() -> [Device] {
        var list: [Device] = []
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            if let data = userDefaults.data(forKey: "devices") {
                do {
                    let decoder = JSONDecoder()
                    let savedDevices = try decoder.decode([Device].self, from: data)
                    list = savedDevices
                } catch {
                    print("Unable to Decode devices (\(error))")
                }
            }
        }
        return list
    }
}
