
import SwiftUI

struct WidgetTile: View {
    
    let device: Device
    let colors: [Color]
    
    @State var isPressed: Bool = false
    
    var body: some View {
        Button(intent: BootButtonIntent(id: device.id)) {
            HStack {
                VStack(alignment: .leading,spacing: 8) {
                    Image(systemName: "power")
                        .fontWeight(.semibold)
                    Text(device.name)
                        .lineLimit(1)
                        .font(Font.system(size: 14))
                        .fontWeight(.bold)
                }
                Spacer(minLength: 0)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 14)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            ContainerRelativeShape()
                .inset(by: 4)
                .fill(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
                .opacity(isPressed ? 0.5 : 1.0)
        }
        .onTapGesture {
            isPressed.toggle()
        }
    }
}

