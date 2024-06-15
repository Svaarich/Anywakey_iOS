
import SwiftUI

struct ButtonRow: View {
    
    @EnvironmentObject var dataService: WatchDS
    
    @State private var date: Date = .now
    @State private var status: Bool = false
    
    let device: Device
    
    let startDevice: () -> Void
    
    var formatter: DateFormatter {
        let format = DateFormatter()
        format.timeStyle = .short
        return format
        
    }
    
    var body: some View {
        Button {
            //send device to ios app
            startDevice()
            WKHapticManager.instance.play(.stop)
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    Image(systemName: dataService.statusList[device.BroadcastAddr] ?? false ? "wifi" : "wifi.slash")
                        .foregroundColor(dataService.statusList[device.BroadcastAddr] ?? false ? .green : .red)
                        .padding(8)
                        .background(.gray.opacity(0.1))
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 0) {
                        Text("updated")
                        Text("\(formatter.string(from: date))")
                            .contentTransition(.numericText())
                            
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    
                    Spacer()
                    if device.isPinned {
                        Image(systemName: "star.fill")
                        .offset(y: -1)
                        .foregroundStyle(Color.custom.starColor)
                    }
                }
                Text(device.name)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                Divider()
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
        .onChange(of: dataService.statusListUpdated) {
            withAnimation(.smooth) {
                date = .now
            }
        }
    }
}
