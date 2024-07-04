
import SwiftUI
import AppIntents

struct BootButtonIntent: AppIntent {
    
    @ObservedObject var widgetData = AnyWidgetData()
    
    static var title: LocalizedStringResource = "Boot device"
    
    @Parameter(title: "Device ID")
    var id: String
    
    init() {
        
    }
    
    init(id: String) {
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        if let index = widgetData.deviceList.firstIndex(where: {$0.id == id } ) {
            _ = Network.instance.boot(device: widgetData.deviceList[index])
        }
        return .result()
    }
}


