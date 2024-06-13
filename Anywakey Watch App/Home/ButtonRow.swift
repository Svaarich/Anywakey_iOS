
import SwiftUI

struct ButtonRow: View {
    
    @EnvironmentObject var dataService: WatchDS
    
    let device: Device
    
    var body: some View {
        Button {
            //send device to ios app
            dataService.sendMessage(device: device)
            WKHapticManager.instance.play(.stop)
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(device.name)
                        .lineLimit(1)
                    if device.isPinned {
                        Image(systemName: "star.fill")
                        .offset(y: -1)
                        .foregroundStyle(Color.custom.starColor)
                    }
                }
                HStack {
                    Image(systemName: "globe")
                        .foregroundStyle(.secondary)
                        .opacity(0.8)
                    Text(device.BroadcastAddr)
                        .lineLimit(1)
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
        }
    }
}
