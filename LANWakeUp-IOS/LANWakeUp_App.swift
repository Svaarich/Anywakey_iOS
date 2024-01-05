import SwiftUI

@main
struct LANWakeUp_App: App {
    private let computer = Computer()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LANWakeUpView(computer: computer)
            }
            .environmentObject(Computer())
        }
    }
}
