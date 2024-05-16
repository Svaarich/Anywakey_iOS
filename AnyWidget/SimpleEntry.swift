import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date = .now
    let list: [Device]
}
