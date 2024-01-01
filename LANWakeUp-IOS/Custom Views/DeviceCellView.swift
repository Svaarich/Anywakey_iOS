import SwiftUI

struct DeviceCellView: View {
    
    @EnvironmentObject var computer: Computer
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var statusColor: Color = .gray
    @State private var isPressed: Bool = false
    @State private var ping: Double = 0
    @State private var showInputAlert: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var showProgressView: Bool = false
    
    @Binding var refreshStatus: Bool
    
    var device: Device
    
    var body: some View {
        HStack {
            bootButton
            deviceInfo
        }
        .padding(.vertical, 8)
        
        // context menu
        .contextMenu {
            contextMenu
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
                if let index = computer.listOfDevices.firstIndex(of: device) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        computer.listOfDevices[index].isPinned.toggle()
                    }
                }
            } label: {
                Text(device.isPinned ? "Unpin" : "Pin")
                Image(systemName: device.isPinned ? "pin.slash" : "pin")
            }
            .tint(DrawingConstants.starColor)
        }
        
        
        //MARK: Alerts
        
        // Delete device alert
        .alert("Are you sure you want to delete '\(device.name)'?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                computer.delete(oldDevice: device)
            }
        }
        
        // Input alert
        .alert("Oops!", isPresented: $showInputAlert)  {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Incorrect input information!")
        }
        
        .onAppear {
            statusColor = colorScheme == .dark ? DrawingConstants.defaultDarkColor :  DrawingConstants.defaultLightColor
            getStatusColor()
        }
        .onChange(of: refreshStatus) { status in
            if status {
                refreshStatusColor()
            }
        }
    }
    
    
    //MARK: Status color functions
    // Get status color of device
    private func getStatusColor() {
//        guard !device.BroadcastAddr.isEmpty else { return statusColor = DrawingConstants.starColor }
        Network.ping(address: device.BroadcastAddr) { duration, status in
            withAnimation(.easeInOut) {
                ping = duration
                statusColor = status ? DrawingConstants.onlineColor : DrawingConstants.offlineColor
                refreshStatus = false
            }
        }
    }
    
    // Refresh status color for device
    private func refreshStatusColor() {
        withAnimation {
            statusColor = colorScheme == .dark ? DrawingConstants.defaultDarkColor : DrawingConstants.defaultLightColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                getStatusColor()
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
                        .foregroundStyle(DrawingConstants.starColor)
                        .padding(.bottom, 3)
                        .shadow(color: DrawingConstants.starColor.opacity(0.4), radius: 7)
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
                            .foregroundStyle(DrawingConstants.starColor)
                            .padding(.leading, 4)
                    }
                } else {
                    Text(device.BroadcastAddr.isEmpty ? "Adress: [Empty]" : "\(device.BroadcastAddr)")
                }
                Spacer()
                if statusColor == DrawingConstants.onlineColor {
                    Text(String(format: "%.3f ms", ping))
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .lineLimit(1)
    }
    
    //MARK: Boot button
    private var bootButton: some View {
        Circle()
            .opacity(colorScheme == .dark ? 0.2 : 0.8)
            .overlay {
                ZStack {
                    if statusColor == DrawingConstants.defaultDarkColor || statusColor == DrawingConstants.defaultLightColor {
                        ProgressView()
                    } else {
                        Image(systemName: "power")
                            .font(Font.system(size: DrawingConstants.imageSize))
                            .foregroundStyle(.white)
                            .transition(.scale)
                    }
                    Circle()
                        .strokeBorder(lineWidth: 2)
                }
                
            }
            .frame(width: 55, height: 55)
            .foregroundStyle(isPressed ? DrawingConstants.pressedButtonColor : statusColor)
            .padding(.trailing)
        
            .onTapGesture {
                //TODO: improve!!!
                if device.MAC.count == 17 {
                    withAnimation(.easeInOut) {
                        isPressed = true
                        _ = computer.boot(device: device)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                            withAnimation {
                                isPressed = false
                            }
                        }
                    }
                } else {
                    let impactMed = UINotificationFeedbackGenerator()
                    impactMed.notificationOccurred(.error)
                    showInputAlert.toggle()
                }
            }
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
                if let index = computer.listOfDevices.firstIndex(of: device) {
                    computer.listOfDevices[index].isPinned.toggle()
                    
                }
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
        static let starColor = Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
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
    @EnvironmentObject var computer: Computer
    @State var refresh: Bool = false
    var device = Device(name: "Test name", MAC: "11:22:33:44:55:66", BroadcastAddr: "1.1.1.1", Port: "45655")
    device.isPinned = true
    return DeviceCellView(computer: _computer, refreshStatus: $refresh, device: device)
        .preferredColorScheme(.dark)
}
