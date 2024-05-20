
import SwiftUI

struct WidgetTile: View {
    
    let device: Device
    let colors: [Color]
    let deviceAmount: Int
    var padding: CGFloat {
        if deviceAmount == 1 {
            return 16
        } else {
            return 8
        }
    }
    
    var body: some View {
        Button(intent: BootButtonIntent(id: device.id)) {
            VStack(alignment: .leading, spacing: 0) {
                Text(device.name)
                    .lineLimit(deviceAmount == 1 ? 3 : 1)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.leading, 4)
                    .padding(.top, deviceAmount == 2 ? 4 : 0)

                Spacer(minLength: 0)
                Image(systemName: "power")
                .fontWeight(.semibold)
                .padding(4)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(padding)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                ContainerRelativeShape()
                    .inset(by: 4)
                    .fill(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
            }
        }
        .buttonStyle(.plain)
    }
}

