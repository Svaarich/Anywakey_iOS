import SwiftUI

@main
struct LANWakeUp_App: App {
    
    @StateObject private var dataService = DeviceDataService()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView(dataService: dataService)
            }
            .environmentObject(dataService)
        }
    }
}
