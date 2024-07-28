
import SwiftUI
import WidgetKit

struct WidgetSettingsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var dataService: DeviceDataService
    
    @State private var widgetColorIndex_1: Int = 2
    @State private var widgetColorIndex_2: Int = 2
    @AppStorage("2widgetMode") var widgetMode: Bool = false
    
    @State private var tileEditingNumber: Int = 1
    
//    let devices: [Device]
    
    private let colors = [
        Color.widget.green,
        Color.widget.blue,
        Color.widget.orange,
        Color.widget.pink,
        Color.widget.purpule,
        Color.widget.yellow
    ]
    
    init() {
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            widgetColorIndex_1 = userDefaults.integer(forKey: "widgetColor_1")
            widgetColorIndex_2 = userDefaults.integer(forKey: "widgetColor_2")
            widgetMode = userDefaults.bool(forKey: "2widgetMode")
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if dataService.allDevices.count > 0 {
                    widget
                        .animation(.smooth, value: widgetMode)
                } else {
                    noDevices
                }
                title
                VStack(spacing: 0) {
                    colorSettings
                    modeToggle
                        .padding(.vertical, 16)
                }
                .disabled(dataService.allDevices.count > 0 ? false : true)
                Spacer()
            }
            .padding()
            .navigationTitle("Widget settings")
        }
        .defaultAppStorage(UserDefaults(suiteName: "group.svarich.anywakey")!)
        .background {
            if colorScheme == .light {
                Color.gray.opacity(0.1).ignoresSafeArea()
            }
        }
        .onTapGesture {
            withAnimation(.smooth(duration: 0.3)) {
                if widgetMode {
                    tileEditingNumber = 0
                } else {
                    tileEditingNumber = 1
                }
            }
        }
        .onChange(of: widgetColorIndex_1) { _ in
            saveIndecies()
            WidgetCenter.shared.reloadAllTimelines()
        }
        .onChange(of: widgetColorIndex_2) { _ in
            saveIndecies()
            WidgetCenter.shared.reloadAllTimelines()
        }
        .onChange(of: widgetMode) { _ in
            if !widgetMode {
                tileEditingNumber = 1
            } else {
                tileEditingNumber = 0
            }
            saveWidgetMode()
            WidgetCenter.shared.reloadAllTimelines()
        }
        .onAppear {
            tileEditingNumber = widgetMode ? 0 : 1
            fetchColors()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

extension WidgetSettingsView {
    
    // MARK: PROPERTIES
    
    private var title: some View {
        HStack {
            Text("Colors")
                .font(.title)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding(.horizontal)
    }
    
    // no devices widget
    private var noDevices: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .foregroundStyle(.gray.opacity(0.0))
        }
        .overlay {
            VStack(alignment: .leading, spacing: 4) {
                Text("Devices not found.")
                    .foregroundStyle(.primary)
                Text("Please add any device in the app.")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                Spacer()
                Text("""
                        *widget supports
                         only 2 devices.
                        """)
                .foregroundStyle(.secondary)
                .font(.caption2)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            .padding(9)
        }
        .padding(9)
        .frame(width: 200, height: 200)
        .background {
            tileBackground
        }
    }
    
    // widget
    private var widget: some View {
        VStack(spacing: widgetMode ? 9 : 0) {
            Tile(colors: colors[widgetColorIndex_1], height: .infinity, tileNumber: 1, devices: dataService.allDevices)
                .opacity(
                    tileEditingNumber == 1 ? 1.0 :
                        tileEditingNumber == 0 ? 1 : 0.4)
                .onTapGesture {
                    withAnimation(.smooth) {
                        tileEditingNumber = 1
                    }
                }
                .zIndex(2)
            if widgetMode {
                Tile(colors: colors[widgetColorIndex_2], height: widgetMode ? .infinity : 0, tileNumber: 2, devices: dataService.allDevices)
                    .opacity(
                        tileEditingNumber == 2 ? 1.0 :
                            tileEditingNumber == 0 ? 1 : 0.4)
                    .onTapGesture {
                        withAnimation(.smooth(duration: 0.3)) {
                            tileEditingNumber = 2
                        }
                    }
                    .transition(.scale.combined(with: .opacity).animation(.smooth))
            }
        }
        .padding(9)
        .frame(width: 200, height: 200)
        .background {
            tileBackground
        }
    }
    
    // colors list
    private var colorSettings: some View {
        VStack(spacing: 0) {
            ForEach(colors) { color in
                Button {
                    withAnimation(.smooth(duration: 0.3)) {
                        performButtonAction(color: color)
                    }
                } label: {
                    HStack {
                        Text(color.description)
                            .foregroundStyle(LinearGradient(colors: color.color, startPoint: .topLeading, endPoint: .bottomTrailing))
                        Spacer()
                        RoundedRectangle(cornerRadius: 10)
                            .fill(LinearGradient(colors: color.color, startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 70, height: 35)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 16)
                    .background(colorScheme == .dark ? .gray.opacity(0.1) : .white)
                }
                .frame(height: 45)
                .buttonStyle(.plain)
                Divider().opacity(colors.last?.id == color.id ? 0 : 1.0)
            }
        }
        .background(colorScheme == .light ? .white : Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var modeToggle: some View {
            Toggle("Show 2 devices", isOn: $widgetMode)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 16)
                .background(colorScheme == .dark ? .gray.opacity(0.2) : .white)
                .frame(height: 45)
                .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var tileBackground: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill()
            .foregroundStyle(.gray.opacity(0.2))
            .frame(width: 200, height: 200)
    }
    
    
    // MARK: FUNCTIONS
    private func getIndex(color: GradientColor) -> Int {
        for index in 0..<colors.count {
            if color.id == colors[index].id {
                return index
            }
        }
        return 0
    }
    
    private func performButtonAction(color: GradientColor) {
        switch tileEditingNumber {
        case 1:
            widgetColorIndex_1 = getIndex(color: color)
        case 2:
            widgetColorIndex_2 = getIndex(color: color)
        case 0:
            widgetColorIndex_1 = getIndex(color: color)
            widgetColorIndex_2 = widgetColorIndex_1
        default:
            break
        }
        saveIndecies()
    }
    
    private func saveIndecies() {
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            userDefaults.setValue(widgetColorIndex_1, forKey: "widgetColor_1")
            userDefaults.setValue(widgetColorIndex_2, forKey: "widgetColor_2")
        }
    }
    
    private func fetchColors() {
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            widgetColorIndex_1 = userDefaults.integer(forKey: "widgetColor_1")
            widgetColorIndex_2 = userDefaults.integer(forKey: "widgetColor_2")
        }
    }
    
    private func saveWidgetMode() {
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            userDefaults.setValue(widgetMode, forKey: "2widgetMode")
        }
    }
    
    private func fetchWidgetMode() {
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            widgetMode = userDefaults.bool(forKey: "2widgetMode")
        }
    }
    
}

#Preview {
    WidgetSettingsView()
}
