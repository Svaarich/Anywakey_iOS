
import SwiftUI

struct OneDeviceView: View {
    
    let color: [Color]
    
    let device: Device
    
    init(devices: [Device], color: [Color]) {
        self.device = devices[0]
        self.color = color
    }
    
    var body: some View {
        WidgetTile(device: device, colors: color, deviceAmount: 1)
            .padding(4)
    }
}
