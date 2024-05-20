
import WidgetKit
import SwiftUI

struct AnyWidgetEntryView: View {
    
    var entry: Provider.Entry
    
    var body: some View {
        if !entry.list.isEmpty {
            VStack(spacing: 0) {
                if entry.list.count == 1 {
                    OneDeviceView(devices: entry.list)
                } else if entry.list.count == 2 {
                    TwoDeviceView(devices: entry.list)
                }
            }
        } else if entry.list.isEmpty {
            noDeviceView
                .padding(12)
        }
    }
}

extension AnyWidgetEntryView {
    
    // MARK: FUNCTIONS
    
    // MARK: PROPERTIES
    
    // main view
    private var deviceListView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                Text("Devices")
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                Image(systemName: "star.fill")
                    .foregroundStyle(Color.custom.starColor)
            }
            Divider()
                .padding(.vertical, 6)
            GeometryReader { geo in
                VStack {
                    ForEach(entry.list) { device in
                        HStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(device.name)
                                    .lineLimit(1)
                                    .frame(width: .infinity)
                            }
                            Spacer(minLength: 4)
                            Button(intent: BootButtonIntent(id: device.id)) {
                                Circle()
                                    .foregroundStyle(.blue)
                                    .overlay {
                                        Image(systemName: "power")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundStyle(.white)
                                            .padding(4)
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                        .frame(height: geo.size.height / 3)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
    
    // no pinned view
    private var noDeviceView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Pinned devices not found")
                .foregroundStyle(.secondary)
            Text("Please pin any device in the app.")
                .foregroundStyle(.tertiary)
                .font(.caption)
            Spacer()
            Text("""
                *only first 2 pinned
                 devices are available.
                """)
            .foregroundStyle(.quaternary)
            .font(.caption2)
        }
    }
}
