
import SwiftUI


struct Tile: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    
    @State var title: String = "Edit widget"
    
    let colors: GradientColor
    let height: CGFloat
    let tileNumber: Int
    let devices: [Device]
    
    let widgetColorIndex: Int = 0
    
    var body: some View {
        tile
            .onAppear(perform: fetchWidgetDevices)
    }
    
    private var tile: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .foregroundStyle(LinearGradient(
                    colors: colors.color,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
                .frame(maxHeight: height)
        }
        .overlay {
            VStack {
                Menu {
                    ForEach(dataService.allDevices) { device in
                        Button {
                            title = device.name
                            if let index = dataService.allDevices.firstIndex(of: device) {
                                saveIndex(index: index)
                            }
                        } label: {
                            HStack {
                                Text(device.name)
                                if device.isPinned {
                                    Image(systemName: "star.fill")
                                }
                            }
                        }
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(title)
                        Text("*tap to edit")
                            .font(.caption)
                            .fontWeight(.regular)
                            .opacity(0.6)
                    }
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                    .font(Font.system(size: 18))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                Image(systemName: "power")
                    .foregroundStyle(.white)
                    .font(Font.system(size: 18))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .opacity(height == .infinity ? 1.0 : 0)
            .padding(16)
        }
    }
    
    private func fetchWidgetDevices() {
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            let name = "widgetDevice_"
            let index = userDefaults.integer(forKey: name + "\(tileNumber)")
            if index >= devices.count {
                title = "Choose device"
            } else {
                title = devices[index].name
            }
        }
    }
    
    private func saveIndex(index: Int) {
        if let userDefaults = UserDefaults(suiteName: "group.svarich.anywakey") {
            let name = "widgetDevice_" 
            userDefaults.setValue(index, forKey: name + "\(tileNumber)")
        }
    }
}
