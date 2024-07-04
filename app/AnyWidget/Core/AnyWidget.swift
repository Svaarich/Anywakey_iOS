import SwiftUI
import WidgetKit

struct AnyWidget: Widget {
    let kind: String = "AnyWidgetList"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                AnyWidgetEntryView(entry: entry)
                    .ignoresSafeArea()
                    .containerBackground(.quaternary, for: .widget)
            } else {
                AnyWidgetEntryView(entry: entry)
                    .ignoresSafeArea()
                    .background()
            }
        }
        .configurationDisplayName("AnyWidget")
        .description("Start up your computer!")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

