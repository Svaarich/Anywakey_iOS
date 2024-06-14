
import SwiftUI

struct ButtonRow: View {
    
    let device: Device
    let dataService: WatchDS
    
    var body: some View {
        Button {
            //send device to ios app
            startDevice()
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
        .onAppear(perform: updateStatus)
    }
    
    func updateStatus() {
        if dataService.session.isReachable {
            dataService.updateStatus()
            date = .now
        }
    }
}
