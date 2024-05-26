
import WidgetKit
import SwiftUI

struct AnyWidgetEntryView: View {
    
    var entry: Provider.Entry
    
    var body: some View {
        if !entry.list.isEmpty {
            VStack(spacing: 0) {
                if !entry.widgetMode {
                    OneDeviceView(
                        devices: entry.list,
                        color: entry.color1.color)
                } else {
                    TwoDeviceView(
                        devices: entry.list,
                        color1: entry.color1.color,
                        color2: entry.color2.color)
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
    
    // no pinned view
    private var noDeviceView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Widget is not configured")
                .foregroundStyle(.secondary)
            Text("Please set up widget in the app.")
                .foregroundStyle(.tertiary)
                .font(.caption)
            Spacer()
            Text("""
                *widget supports
                 only 2 devices.
                """)
            .foregroundStyle(.quaternary)
            .font(.caption2)
        }
    }
}
