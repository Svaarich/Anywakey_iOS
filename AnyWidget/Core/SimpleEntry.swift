import WidgetKit

struct SimpleEntry: TimelineEntry {
    let color1: GradientColor
    let color2: GradientColor
    let date: Date = .now
    let list: [Device]
    let widgetMode: Bool
}
