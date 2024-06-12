
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
                            dataService.sendMessage(device: device)
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
        .onAppear(perform: dataService.askForDevices)
        .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        MenuView()
                    } label: {
                        Image(systemName: "list.bullet")
                    }

                }
        }
        .navigationTitle("Devices")
        .toolbar(dataService.allDevices.isEmpty ? .hidden : .visible)
                }
        }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
