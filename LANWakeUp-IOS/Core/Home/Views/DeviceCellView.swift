import SwiftUI

struct DeviceCellView: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isAccesible: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var animate: Bool = false
    
    @State private var starOpacity: CGFloat = 0.0
    @State private var ping: Double = 0.0
    
    @Binding var refreshStatus: Bool
    
    let device: Device
    
    var body: some View {
        HStack {
            BootButton(refreshStatus: $refreshStatus, device: device)
            deviceInfo
        }
        .padding(.vertical, 8)
        
        // context menu
        .contextMenu {
            contextMenu
        }
        
        .sheet(isPresented: $showDeleteAlert) {
            DeleteDeviceSheet(device: device)
                .presentationDetents([.medium])
        }
        
        // swipe actions
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            // Delete button
            Button {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showDeleteAlert.toggle()
                }
            } label: {
                Text("Delete")
                Image(systemName: "trash")
            }
            .tint(.pink)
            
            // Pin button
            Button {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dataService.pinToggle(device: device)
                }
            } label: {
                Text(device.isPinned ? "Unpin" : "Pin")
                Image(systemName: device.isPinned ? "pin.slash" : "pin")
            }
            .tint(Color.custom.starColor)
        }
        
        .onAppear {
            addAnimation()
            getStatus()
        }
        .onChange(of: refreshStatus) { status in
            if status {
                getStatus()
            }
        }
        
        
        //MARK: Alerts
        // Delete device alert
//        .alert("Are you sure you want to delete '\(device.name)'?", isPresented: $showDeleteAlert) {
//            Button("Cancel", role: .cancel) {}
//            Button("Delete", role: .destructive) {
//                dataService.delete(device: device)
//            }
//        }
    }
    
    private func addAnimation() {
        guard !animate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5...1.0)) {
            withAnimation(
                Animation
//                    .linear(duration: Double.random(in: 1...3))
                    .linear(duration: Double.random(in: 2...3))
                    .repeatForever(autoreverses: true)
            ) {
                starOpacity = 0.4
            }
        }
    }
    
    //MARK: Status color functions
    // Get status color of device
    private func getStatus() {
        Network.ping(address: device.BroadcastAddr) { duration, status in
            withAnimation(.easeInOut) {
                ping = duration
                isAccesible = status
                refreshStatus = false
            }
        }
    }
    
    //MARK: Device information
    private var deviceInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(device.name.isEmpty ? "[No name]" : device.name)
                    .foregroundStyle(.primary)
                    .font(.headline)
                if device.isPinned {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.custom.starColor)
                        .padding(.bottom, 3)
                        .shadow(color: Color.custom.starColor.opacity(starOpacity), radius: 7)
                }
            }
            HStack(spacing: 4) {
                // adress icon
                if !device.BroadcastAddr.isEmpty {
                    Image(systemName: "network")
                        .foregroundStyle(.secondary)
                }
                
                // empty adress indicator
                if device.BroadcastAddr.isEmpty {
                    HStack(spacing: 0) {
                        Text("Empty adress")
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(Color.custom.starColor)
                            .padding(.leading, 4)
                    }
                } else {
                    Text(device.BroadcastAddr.isEmpty ? "Adress: [Empty]" : "\(device.BroadcastAddr)")
                }
                Spacer()
                
                // Ping block
                if isAccesible {
                    pingInfo
                }
            }
            .frame(maxWidth: .infinity)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .lineLimit(1)
    }
    
    // MARK: Ping block
    private var pingInfo: some View {
        HStack(spacing: 4) {
            Image(systemName: "stopwatch")
            Text(ping.asPingString())
                .contentTransition(.numericText())
        }
        .frame(width: 100, alignment: .trailing)
        .font(.caption)
        .foregroundStyle(.tertiary)
    }
    
    //MARK: Context menu
    private var contextMenu: some View {
        VStack {
            //Edit Button
            Button {
                // Edit view and action
            } label: {
                Text("Edit")
                Image(systemName: "square.and.pencil")
            }
            
            // Pin button
            Button {
                dataService.pinToggle(device: device)
            } label: {
                Text(device.isPinned ? "Unpin" : "Pin")
                Image(systemName: device.isPinned ? "pin.slash" : "pin")
            }
            
            // Delete button
            Button(role: .destructive) {
                showDeleteAlert.toggle()
            } label: {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
    }
    
    private struct DrawingConstants {
        
        static let defaultDarkColor: Color = .gray
        static let defaultLightColor: Color = .gray.opacity(0.5)
        static let pressedButtonColor: Color = .blue
        
        static let onlineColor: Color = .green
        static let offlineColor: Color = .pink
        
        static let imageSize: CGFloat = 30.0
        static let fontSize: CGFloat = 15.0
    }
}


#Preview {
    @EnvironmentObject var dataService: DeviceDataService
    @State var refresh: Bool = false
    let device = Device(name: "Test name", MAC: "11:22:33:44:55:66", BroadcastAddr: "1.1.1.1", Port: "45655", isPinned: true)
    return DeviceCellView(refreshStatus: $refresh, device: device)
        .preferredColorScheme(.dark)
}
