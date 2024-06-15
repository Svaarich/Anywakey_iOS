
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
                startDevice()
                WKHapticManager.instance.play(.click)
            }
        } label: {
            deviceCard
        }
        .onChange(of: dataService.statusListUpdated) {
            withAnimation(.smooth) {
                date = .now
            }
        }
    }
}

extension ButtonRow {
    // device card
    private var deviceCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                statusSection
                    .animation(.smooth, value: showProgress)
                Spacer()
                if device.isPinned {
                    starSection
                }
            }
            deviceName
            Divider()
            deviceAddress
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
    
    // device address section
    private var deviceAddress: some View {
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
    
    // device name section
    private var deviceName: some View {
        Text(device.name)
            .fontWeight(.semibold)
            .lineLimit(2)
    }
    
    // star view
    private var starSection: some View {
        Image(systemName: "star.fill")
            .offset(y: -1)
            .foregroundStyle(Color.custom.starColor)
    }
    
    // status view
    private var statusSection: some View {
        HStack {
            .frame(width: 20, height: 20)
            .padding(8)
            .background(.gray.opacity(0.1))
            .clipShape(Circle())
            .rotationEffect(.degrees(rotationAngle))
            
            VStack(alignment: .leading, spacing: 0) {
                    Text("\(formatter.string(from: date))")
                        .contentTransition(.numericText())
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
    }
}
