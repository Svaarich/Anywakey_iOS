
import SwiftUI
import WatchConnectivity

class WatchDS: NSObject, WCSessionDelegate, ObservableObject {
    
    @Published var allDevices: [Device] = []
    @Published var statusList: [String : Bool] = [ : ]
    
    var session: WCSession
    
    init(session: WCSession = .default, devices: [Device] = []) {
        self.session = session
        allDevices = devices
        super.init()
        self.session.delegate = self
        session.activate()
        self.fecthSavedDevices()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("The session has completed activation.")
        }
    }
    
    
    // receive Data
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        DispatchQueue.main.async {
            guard let message = try? JSONDecoder().decode([Device].self, from: messageData) else {
                return
            }
            self.allDevices = message.sorted(by: { $0.isPinned && !$1.isPinned })
            self.saveDevices()
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.statusList = message["status"] as! [String : Bool]
        }
    }
    
    // send device to boot
    func sendMessage(device: Device) {
        guard let data = try? JSONEncoder().encode(device) else {
            return
        }
        if session.isReachable {
            session.sendMessageData(data, replyHandler: nil) { error in
                print("Error sending device: \(error)")
            }
        }
    }
    
    // get list of devices
    func askForDevices() {
        let message = ["action" : "sendDevices"]
        if session.isReachable {
            session.sendMessage(message, replyHandler: nil) { error in
                print("Error requestion devices: \(error)")
            }
        }
    }
    
    // MARK: Save data
    
    func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    private func saveDevices() {
        do {
            // encode
            let encoder = JSONEncoder()
            let data = try encoder.encode(allDevices)
            
            // create new URL
            let url = getDocumentDirectory().appending(path: "devices")
            
            // write data
            try data.write(to: url)
            
        } catch {
            print("Saving data error: \(error)")
        }
    }
    
    func fecthSavedDevices() {
        DispatchQueue.main.async {
            do {
                // get url
                let url = self.getDocumentDirectory().appending(path: "devices")
                
                // get data
                let data = try Data(contentsOf: url)
                
                // decode
                let decoder = JSONDecoder()
                self.allDevices = try decoder.decode([Device].self, from: data)
                
            } catch {
                print("Error load devices: \(error)")
            }
        }
    }
}


