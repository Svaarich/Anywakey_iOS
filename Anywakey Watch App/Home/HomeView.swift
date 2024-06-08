
import SwiftUI

struct HomeView: View {
    
    @State private var allDevices: [Device] = []
    
    var body: some View {
        ScrollView {
            VStack {
                if allDevices.isEmpty {
                    Text("Please add device in the iOS app.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(allDevices) { device in
                        Button {
                            
                        } label: {
                            HStack {
                                Text(device.name)
                                Spacer()
                                Image(systemName: "star.fill")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(allDevices.isEmpty ? "No devices 🥲" : "Devices")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
