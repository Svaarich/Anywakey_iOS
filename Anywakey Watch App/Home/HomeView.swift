
import SwiftUI
import WatchConnectivity

struct HomeView: View {
    
    @EnvironmentObject var dataService: WatchDS
    
    @State var loading: Bool = true
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if loading && dataService.allDevices.isEmpty {
                loadingView
            } else {
                if dataService.allDevices.isEmpty {
                    noDevicesView
                } else {
                    list
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationLink {
                    MenuView {
                        dataService.askForDevices()
                    }
                } label: {
                    Image(systemName: "list.bullet")
                }

            }
        }
        .navigationTitle {
            Text("Devices")
                .foregroundStyle(.green)
        }
        .toolbar(dataService.allDevices.isEmpty ? .hidden : .visible)
        .onReceive(timer) { _ in
            askForDevices()
        }
    }
}

extension HomeView {
    
    // MARK: FUNCTIONS
    private func askForDevices() {
        if dataService.session.isReachable {
            dataService.askForDevices()
            timer.upstream.connect().cancel()
            withAnimation(.spring) {
                loading = false
            }
        }
    }
    
    // MARK: PROPERTIES
    
    // loading progress view
    private var loadingView: some View {
        VStack(alignment: .leading) {
            Text("Awaiting connection with iPhone")
            ProgressView()
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    // empty list view
    private var noDevicesView: some View {
        VStack(alignment: .leading) {
            Text("Device list is empty.")
            Text("Please add device in the iOS app.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    // devices list
    private var list: some View {
        List {
            // pinned devices
            if !dataService.allDevices.filter({ $0.isPinned }).isEmpty {
                Section {
                    ForEach(dataService.allDevices.filter( { $0.isPinned } )) { device in
                        ButtonRow(device: device) {
                            dataService.sendMessage(device: device)
                        }
                    }
                } header: {
                    HStack {
                        Text("Pinned")
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color.custom.starColor)
                    }
                }
            }
            
            // not pinned devices
            if !dataService.allDevices.filter({ !$0.isPinned }).isEmpty {
                Section {
                    ForEach(dataService.allDevices.filter( { !$0.isPinned } )) { device in
                        ButtonRow(device: device) {
                            dataService.sendMessage(device: device)
                        }
                    }
                } header: {
                    HStack {
                        Text("Devices")
                        Image(systemName: "display.2")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .listStyle(.carousel)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
