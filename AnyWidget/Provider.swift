
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    
    @ObservedObject var widgetData = AnyWidgetData()
    
    func placeholder(in context: Context) -> SimpleEntry {
        widgetData.fetchPinnedDevices()
        return SimpleEntry(list: widgetData.deviceList)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        widgetData.fetchPinnedDevices()
        completion(SimpleEntry(list: widgetData.deviceList))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []
        widgetData.fetchPinnedDevices()
        entries.append(SimpleEntry(list: widgetData.deviceList))
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
