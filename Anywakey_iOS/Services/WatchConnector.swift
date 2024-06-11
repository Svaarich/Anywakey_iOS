
import WatchConnectivity

final class WatchConnector: NSObject {
    
    var session: WCSession
    let dataService: DeviceDataService
    
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
            _ = Network.instance.boot(device: device)
        } catch {
            print("Error parsing watch message: \(error)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let action = message["action"] as? String {
            if action == "sendDevices" {
                let devices = dataService.allDevices
                sendMessageData(list: devices)
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
    
    // send devices data to apple watch
    func sendMessageData(list: [Device]) {
        guard let data = try? JSONEncoder().encode(list) else {
            return
        }
        if WCSession.isSupported() {
            self.session.sendMessageData(data, replyHandler: nil) { (error) in
                print(error.localizedDescription)
            }
        }
    }
}
