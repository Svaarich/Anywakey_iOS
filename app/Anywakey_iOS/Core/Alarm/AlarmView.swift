
import SwiftUI

struct AlarmView: View {
    
    var body: some View {
        Button("notify") {
            notify()
        }
        Button("request") {
            request()
        }
    }
    
    private func request() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error {
                print(error.localizedDescription)
            }
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
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}

#Preview {
    AlarmView()
}
