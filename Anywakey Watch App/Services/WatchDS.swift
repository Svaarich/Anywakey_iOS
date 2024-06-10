
import SwiftUI
import WatchConnectivity

class WatchDS: NSObject, WCSessionDelegate, ObservableObject {

    @Published var allDevices: [Device] = []
    
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
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
            self.allDevices = message
            self.saveSevices()
        }
    }
    
    private func saveSevices() {
        let data = allDevices
        let userDefaults = UserDefaults.standard
        do {
            let encoder = JSONEncoder()
            let savedDevices = try encoder.encode(data)
            userDefaults.set(savedDevices, forKey: "watchDevices")
        } catch {
            print("Unable to Encode Array of devices (\(error))")
        }
        
    }
    
    func fecthSavedDevices() {
        if let data = UserDefaults.standard.data(forKey: "watchDevices") {
            do {
                let decoder = JSONDecoder()
                let savedDevices = try decoder.decode([Device].self, from: data)
                allDevices = savedDevices
                allDevices = [.init(name: "test", MAC: "", BroadcastAddr: "", Port: "")]
            } catch {
                print("Unable to Decode devices (\(error))")
            }
        }
    }
}


