

import SwiftUI

struct NoDevicesView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var animate: Bool = false
    @Binding var isPresented: Bool
    
    let secondaryAccenColor = Color("SecondaryAccentColor")
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("There are no devices")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("Are you a productive person and can't wait to start your coputer remotely?\nClick the button to add a device to the list!")
                    .padding(.bottom, 20)
                Button {
//                    AddDeviceView(isPresented: $isPresented)
                    withAnimation(.spring) {
                        isPresented.toggle()
                    }
                } label: {
                    HStack {
                        Text("Add device")
                        Image(systemName: "pc")
                            .symbolRenderingMode(.hierarchical)
                    }
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(animate ? secondaryAccenColor : .blue)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal, animate ? 30 : 50)
                        .scaleEffect(animate ? 1.1 : 1.0)
                        .offset(y: animate ? -7 : 0)
                }
            }
            
            .multilineTextAlignment(.center)
            .padding(40)
            .shadow(
                color: animate ? secondaryAccenColor.opacity(colorScheme == .dark ? 0.3 : 0.7) : .blue.opacity(colorScheme == .dark ? 0.5 : 0.7),
                radius: animate ? 30 : 10,
                x: 0,
                y: animate ? 50 : 30)
            .onAppear(perform: addAnimation)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func addAnimation() {
        guard !animate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
                    .repeatForever()
            ) {
                animate.toggle()
            }
        }
    }
}

#Preview {
    @State var isPresented: Bool = true
    return NoDevicesView(isPresented: $isPresented)
}
