
import SwiftUI
import WatchConnectivity

struct HomeView: View {
    
    @ObservedObject var dataService = WatchDS()
    
    var body: some View {
        ScrollView {
            VStack {
                if dataService.allDevices.isEmpty {
                    Text("Please add device in the iOS app.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(dataService.allDevices) { device in
                        Button {
                            //send device to ios app
                            if WCSession.default.isReachable {
                                let message = ["boot" : device] as! [String : Device]
                                WCSession.default.sendMessage(message, replyHandler: nil) { error in
                                    print("Watch error sending message: \(error)")
                                    print(device)
                                }
                            }
                        } label: {
                            HStack {
                                Text(device.name)
                                    .lineLimit(1)
                                Spacer()
                                if device.isPinned {
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(.yellow)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(dataService.allDevices.isEmpty ? "No devices 🥲" : "Devices")
        .onAppear {
//            dataService.fecthSavedDevices()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
