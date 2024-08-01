
import SwiftUI
import BackgroundTasks


struct AlarmView: View {
    
    let device: Device = Device(name: "", MAC: "", BroadcastAddr: "", Port: "")
    
    var body: some View {
        VStack {
            Button("Local Message Autorization") {
                Network.instance.sendTG()
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                        
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }.buttonStyle(.borderedProminent)
                .padding()
            
            Button("Schedule Background Task") {
                notify()
            }.buttonStyle(.bordered)
                .tint(.red)
                .padding()
            
        }
    }
    
    private func notify() {
        let content = UNMutableNotificationContent()
        content.title = "🖥️ Device name"
        content.body = "🫡 ...in the process of waking up!"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: device.id, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }

}

//#Preview {
//    AlarmView()
//}
