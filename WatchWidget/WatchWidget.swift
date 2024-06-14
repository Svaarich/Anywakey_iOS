//
//  WatchWidget.swift
//  WatchWidget
//
//  Created by Svarychevskyi Danylo on 14.06.2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry()
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        entries.append(SimpleEntry())

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date = .now
}

struct WatchWidgetEntryView : View {
    
    @Environment(\.widgetFamily) private var family
    
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .accessoryCircular:
            return circularView
        case .accessoryCorner:
            return circularView
        case .accessoryRectangular:
            return circularView
        case .accessoryInline:
            return circularView
        @unknown default:
            return circularView
        }
    }
    
    private var circularView: some View {
        Image(systemName: "togglepower")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.white)
            .padding(6)
            .background(
                Circle()
                    .foregroundStyle(Color(red: 25/255, green: 25/255, blue: 25/255))
            )
            .padding(2)
    }
    
    private var cornerView: some View {
        Circle()
    }
    private var crectangularView: some View {
        Circle()
    }
    
    private var inlineView: some View {
        Text("Anywakey")
    }
}

@main
struct WatchWidget: Widget {
    let kind: String = "WatchWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(watchOS 10.0, *) {
                WatchWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WatchWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Anywakey")
        .description("App shortcut")
    }
}

#Preview(as: .accessoryRectangular) {
    WatchWidget()
} timeline: {
    SimpleEntry()
}
