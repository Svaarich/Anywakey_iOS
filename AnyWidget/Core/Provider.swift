
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    
    @ObservedObject var widgetData = AnyWidgetData()
    
    let colors = [
        Color.widget.green,
        Color.widget.blue,
        Color.widget.orange,
        Color.widget.pink,
        Color.widget.purpule,
        Color.widget.yellow
    ]
    
    func placeholder(in context: Context) -> SimpleEntry {
        widgetData.fetchColorIndecies()
        widgetData.fetchPinnedDevices()
        return SimpleEntry(
            color1: colors[widgetData.indexColor1],
            color2: colors[widgetData.indexColor2],
            list: widgetData.deviceList)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        widgetData.fetchColorIndecies()
        widgetData.fetchPinnedDevices()
        completion(SimpleEntry(
            color1: colors[widgetData.indexColor1],
            color2: colors[widgetData.indexColor2],
            list: widgetData.deviceList))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []
        widgetData.fetchColorIndecies()
        widgetData.fetchPinnedDevices()
        entries.append(SimpleEntry(
            color1: colors[widgetData.indexColor1],
            color2: colors[widgetData.indexColor2],
            list: widgetData.deviceList))
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
