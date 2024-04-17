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
    @Binding var isCopied: Bool
    
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
        
        // delete device confirmation
        .sheet(isPresented: $showDeleteAlert) {
            DeleteDeviceSheet(device: device, dismissParentView: .constant(false))
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
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                getStatus()
            }
            
        }
        .onChange(of: refreshStatus) { status in
            if status {
                getStatus()
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

extension DeviceCellView {
    
    // MARK: FUNCTIONS
    
    // Just add animations
    private func addAnimation() {
        guard !animate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5...1.0)) {
            withAnimation(
                Animation
                    .linear(duration: Double.random(in: 2...3))
                    .repeatForever(autoreverses: true)
            ) {
                starOpacity = 0.4
            }
        }
    }
    
    // Get status color of device
    private func getStatus() {
        Network.instance.ping(address: device.BroadcastAddr) { duration, status in
            withAnimation(.easeInOut) {
                ping = duration
                isAccesible = status
            }
        }
    }
    
    // MARK: PROPERTIES
    // Device information
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
                
                // Empty adress indicator
                if device.BroadcastAddr.isEmpty {
                    HStack(spacing: 0) {
                        Text("Empty address")
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(Color.custom.starColor)
                            .padding(.leading, 4)
                    }
                } else {
                    Text(device.BroadcastAddr.isEmpty ? "Address: [Empty]" : "\(device.BroadcastAddr)")
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
    
    // Ping block
    private var pingInfo: some View {
        HStack(spacing: 4) {
            Image(systemName: "stopwatch")
            Text(ping.pingAsString())
                .contentTransition(.numericText())
        }
        .frame(width: 80, alignment: .leading)
        .font(.caption)
        .foregroundStyle(.tertiary)
    }
    
    // Context menu
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
            
            // Copy button
            Button {
                device.exportJSON()
                isCopied = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isCopied = false
                }
            } label: {
                Text("Copy")
                Image(systemName: "doc.on.doc")
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
}


#Preview {
    @EnvironmentObject var dataService: DeviceDataService
    @State var refresh: Bool = false
    let device = Device(name: "Test name", MAC: "11:22:33:44:55:66", BroadcastAddr: "1.1.1.1", Port: "45655", isPinned: true)
    return DeviceCellView(refreshStatus: $refresh, isCopied: .constant(false), device: device)
        .preferredColorScheme(.dark)
}
