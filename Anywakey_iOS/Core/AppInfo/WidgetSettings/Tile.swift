
import SwiftUI


struct Tile: View {
    
    let colors: GradientColor
    let height: CGFloat
    
    var body: some View {
        tile
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
                    HStack(spacing: 2) {
                        Text(title)
                        Image(systemName: "rectangle.and.hand.point.up.left.filled")
                            .offset(y: 3)
                    }
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
