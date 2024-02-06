
import SwiftUI

struct BootButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var statusColor: Color = .gray
    @State var isPressed: Bool = false
    @State var showInputAlert: Bool = false
    
    @Binding var refreshStatus: Bool
    
    let device: Device
    
    var body: some View {
        Circle()
            .opacity(colorScheme == .dark ? 0.2 : 0.8)
            .overlay {
                ZStack {
                    if statusColor == DrawingConstants.defaultDarkColor || statusColor == DrawingConstants.defaultLightColor {
                        ProgressView()
                    } else {
                        Image(systemName: "power")
                            .font(.largeTitle)
                            .scaleEffect(0.9)
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
                        HapticManager.instance.impact(style: .soft)
                        _ = Network.instance.boot(device: device)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                            withAnimation {
                                isPressed = false
                            }
                        }
                    }
                } else {
                    HapticManager.instance.notification(type: .warning)
                    showInputAlert.toggle()
                }
            }
            .onAppear {
                statusColor = colorScheme == .dark ? DrawingConstants.defaultDarkColor :  DrawingConstants.defaultLightColor
                getStatusColor()
            }
            .onChange(of: refreshStatus) { _ in
                refreshStatusColor()
            }
            // Input alert
            .alert("Oops!", isPresented: $showInputAlert)  {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Incorrect input information!")
            }
    }
    
    private struct DrawingConstants {
        
        static let defaultDarkColor: Color = .gray
        static let defaultLightColor: Color = .gray.opacity(0.5)
        static let pressedButtonColor: Color = .blue
        
        static let onlineColor: Color = .green
        static let offlineColor: Color = .pink
    }
}

extension BootButton {
    
    // MARK: FUNCTIONS
    
    // Get status color of device
    private func getStatusColor() {
        Network.instance.ping(address: device.BroadcastAddr) { duration, status in
            withAnimation(.easeInOut) {
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
    
    // MARK: PROPERTIES
    
}

#Preview {
    @State var refresh = false
    return BootButton(refreshStatus: $refresh, device: Device(name: "test", MAC: "11:11:11:11", BroadcastAddr: "1.1.1.1", Port: "1"))
}
