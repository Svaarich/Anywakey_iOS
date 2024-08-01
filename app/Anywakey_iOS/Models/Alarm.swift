
import Foundation
import UserNotifications

public struct Alarm: Hashable, Identifiable {
    let device: Device
//    let time: Date
    public let id: String = UUID().uuidString
    
    // boot computer using pre-configured alarm
    func boot() {
        _ = Network.instance.boot(device: device)
    }
    func notify() {
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

