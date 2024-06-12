import SwiftUI

@main
struct Anywakey_iOS_App: App {
    
    @StateObject private var dataService = DeviceDataService()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView(dataService: dataService, connector: WatchConnector(dataService: dataService))
            }
            .environmentObject(dataService)
            .ignoresSafeArea(.keyboard)
        }
    }
}
