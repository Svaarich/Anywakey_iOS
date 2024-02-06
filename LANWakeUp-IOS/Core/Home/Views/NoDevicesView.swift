import SwiftUI

struct NoDevicesView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var animate: Bool = false
    @State private var gradientAngle: Double = 0
    
    @Binding var isPresented: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                description
                button
            }
            .padding(40)
            .onAppear {
                addAnimation()
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension NoDevicesView {
    
    // MARK: FUNCTIONS
    
    private func addAnimation() {
        guard !animate else { return } // return if already animating
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            // movement, scale effect of button
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
                    .repeatForever()
            ) {
                animate.toggle()
            }
            
            // rotating gradient
            withAnimation(
                Animation
                    .linear(duration: 2.0)
                    .repeatForever(autoreverses: false)
            ) {
                gradientAngle = 360
            }
        }
    }
}


extension NoDevicesView {
    
    // MARK: PROPERTIES
    
    // description
    private var description: some View {
        Group {
            Text("There are no devices")
                .font(.title)
                .fontWeight(.semibold)
            Text("Are you a productive person and can't wait to start your coputer remotely?\nClick the button to add a device to the list!")
                .padding(.bottom, 20)
        }
        .multilineTextAlignment(.center)
    }
    
    // button
    private var button: some View {
        Button {
            withAnimation(.spring) {
                isPresented.toggle()
            }
        } label: {
            HStack {
                Text("Add device")
                Image(systemName: "pc")
            }
            .foregroundStyle(.primary)
            .font(.headline)
            .frame(height: 55)
            .frame(maxWidth: .infinity)

            // background
            .background {
                shadowGradient
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal, animate ? 30 : 50)
            .scaleEffect(animate ? 1.1 : 1.0)
            .offset(y: animate ? -7 : 0)
            
            // shadow
            .shadow(
                color: .blue.opacity(colorScheme == .dark ? 0.5 : 0.7),
                radius: animate ? 30 : 10,
                x: 0,
                y: animate ? 40 : 30)
        }
        .buttonStyle(.plain)
    }
    
    // gradient shadow
    private var shadowGradient: some View {
        Rectangle()
            .fill(
                AngularGradient(colors: [Color.custom.secondaryAccenColor, .blue], center: .center, angle: .degrees(gradientAngle))
            )
            .blur(radius: 35)
            .saturation(colorScheme == .dark ? 2.0 : 1.5)
    }
}

#Preview {
    @State var isPresented: Bool = true
    return NoDevicesView(isPresented: $isPresented)
}
