
import SwiftUI
import WatchConnectivity

struct HomeView: View {
    
    @ObservedObject var dataService = WatchDS()
    
    @State var loading: Bool = true
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if loading && dataService.allDevices.isEmpty {
                VStack(alignment: .leading) {
                    Text("Awaiting connection with iPhone")
                    ProgressView()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                if dataService.allDevices.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Device list is empty.")
                        Text("Please add device in the iOS app.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    List {
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
        }
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
        .onReceive(timer) { _ in
            if dataService.session.isReachable {
                dataService.askForDevices()
                timer.upstream.connect().cancel()
                withAnimation(.spring) {
                    loading = false
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
