
import SwiftUI

struct HomeView: View {
    
    @ObservedObject var dataService = WatchDS()
    @State private var isPressed: Bool = false
    @State var loading: Bool = true
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if loading && dataService.allDevices.isEmpty {
                loadingView
            } else {
                if dataService.allDevices.isEmpty {
                    // empty list view
                    noDevicesView
                } else {
                    // device list view
                    list
                }
            }
        }
        .navigationTitle {
            Text("Devices")
                .foregroundStyle(.green)
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
        // hide toolbar
        .toolbar(dataService.allDevices.isEmpty ? .hidden : .visible)
        
        // ask for devices
        .onReceive(timer) { _ in
            deviceRequest()
        }
    }
    
    
}

extension HomeView {
    
    // MARK: PROPERTIES
    
    // progress view
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
            ForEach(dataService.allDevices) { device in
                ButtonRow(device: device)
            }
        }
        .listStyle(.carousel)
    }
    
    
    private func deviceRequest() {
        if dataService.session.isReachable {
            dataService.askForDevices()
            timer.upstream.connect().cancel()
            withAnimation(.spring) {
                loading = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(
            dataService: WatchDS(devices: [
                .init(name: "Lalala",
                      MAC: "11:11:11:11:11:!1",
                      BroadcastAddr: "123.123.123.123",
                      Port: "65001"),
                .init(name: "Lalala",
                      MAC: "11:11:11:11:11:!1",
                      BroadcastAddr: "myhostlalalalarge name",
                      Port: "65001"),
                .init(name: "Lalala",
                      MAC: "11:11:11:11:11:!1",
                      BroadcastAddr: "1.1.1.1",
                      Port: "65001"),
                .init(name: "Lalala",
                      MAC: "11:11:11:11:11:!1",
                      BroadcastAddr: "1.1.1.1",
                      Port: "65001"),]),
            loading: false)
    }
}
