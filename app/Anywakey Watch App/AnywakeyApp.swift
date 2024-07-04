
import SwiftUI

@main
struct Anywakey_Watch_AppApp: App {
    
    @StateObject var dataService: WatchDS = WatchDS()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
            .environmentObject(dataService)
        }
    }
}
