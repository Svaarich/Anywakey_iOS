
import SwiftUI

struct BigBootButton: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var animate: Bool = false
    let device: Device
    
    var body: some View {
        Button {
            if isValidInput() {
                _ = Network.instance.boot(device: device)
            }
        } label: {
            HStack {
                Text(isValidInput() ? "Boot device".uppercased() : "Wrong input".uppercased())
                    .foregroundStyle(isValidInput() ? .blue : Color.secondary)
                    .fontWeight(.semibold)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity((colorScheme == .dark ? 0.2 : 0.1)))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .background {
                        HStack {
                            ForEach(0..<12) {_ in
                                if !isValidInput() {
                                    Image(systemName: "exclamationmark.triangle")
                                        .foregroundStyle(.red.opacity(colorScheme == .dark ? 0.5 : 0.4))
                                        .offset(y: .random(in: -5...5) * 10)
                                        .offset(y: animate ? .random(in: -4...4) : 0.0)
                                        .scaleEffect(animate ? .random(in: 1...10) / 10 : .random(in: 0.1...1.0))
                                        .opacity(animate ? .random(in: 0.3...1.0) : 1.0)
                                } else {
                                    Image(systemName: "togglepower")
                                        .foregroundStyle(.gray.opacity(colorScheme == .dark ? 0.3 : 0.2))
                                        .offset(y: .random(in: -5...5) * 10)
                                        .offset(y: animate ? .random(in: -4...4) : 0.0)
                                        .scaleEffect(animate ? .random(in: 1...10) / 10 : .random(in: 0.1...1.0))
                                        .opacity(animate ? .random(in: 0.3...1.0) : 1.0)
                                }
                            }
                        }
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
            }
        }
        .disabled(!isValidInput())
        .transition(.opacity)
        .animation(.snappy(duration: 10).repeatForever(), value: animate)
        .onAppear {
            animate = true
        }
    }
    
    private func isValidInput() -> Bool {
        if device.MAC.isValidMAC() && device.BroadcastAddr.isValidAdress() {
            return true
        } else {
            return false
        }
    }
}
