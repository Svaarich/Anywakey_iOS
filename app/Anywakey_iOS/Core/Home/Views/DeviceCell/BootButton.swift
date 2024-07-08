
import SwiftUI

struct BootButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var statusColor: Color = .gray
    @State var isPressed: Bool = false
    @State private var rotationAngle: Double = 0
    
    @Binding var refreshStatus: Bool
    @Binding var showWrongInput: Bool
    
    @State var timer: Timer?

    let device: Device
    
    var body: some View {
        Circle()
            .opacity(colorScheme == .dark ? 0.2 : 0.8)
            .overlay {
                ZStack {
                    if statusColor == DrawingConstants.defaultDarkColor || statusColor == DrawingConstants.defaultLightColor {
                        ProgressView()
                    } else {
                        Image(systemName: isPressed ? "checkmark.circle" : "power")
                            .font(.largeTitle)
                            .scaleEffect(0.9)
                            .rotationEffect(.degrees(rotationAngle))
                            .foregroundStyle(.white)
                            .transition(.scale)
                            .animation(.smooth, value: isPressed)
                    }
                    Circle()
                        .strokeBorder(lineWidth: 2)
                }
                
            }
            .frame(width: 55, height: 55)
            .foregroundStyle(isPressed ? DrawingConstants.pressedButtonColor : statusColor)
            .padding(.trailing)
        
            .onTapGesture {
                if device.BroadcastAddr.isValidAdress() && device.MAC.isValidMAC() {
                    withAnimation(.easeInOut) {
                        HapticManager.instance.impact(style: .soft)
                        _ = Network.instance.boot(device: device)
                    }
                    withAnimation(.smooth) {
                        animate()
                    }
                } else {
                    HapticManager.instance.notification(type: .warning)
                    showWrongInput = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        showWrongInput = false
                    }
                }
            }
            .onAppear {
//                statusColor = colorScheme == .dark ? DrawingConstants.defaultDarkColor :  DrawingConstants.defaultLightColor
                getStatusColor()
                timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { _ in
                    getStatusColor()
                }
            }
            .onDisappear {
                timer?.invalidate()
            }
            .onChange(of: refreshStatus) { _ in
                refreshStatusColor()
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
    
    private func animate() {
        isPressed = true
        rotationAngle += 360
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            rotationAngle -= 360
            isPressed = false
        }
    }
    
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
