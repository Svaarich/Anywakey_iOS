
import SwiftUI

struct TwoDeviceView: View {
    
    let device1: Device
    let device2: Device
    
    let color1: [Color]
    let color2: [Color]
    
    
    init(devices: [Device], color1: [Color], color2: [Color]) {
        self.device1 = devices[0]
        self.device2 = devices[1]
        self.color1 = color1
        self.color2 = color2
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // device 1
            WidgetTile(device: device1, colors: color1, deviceAmount: 2)
            //device 2
            WidgetTile(device: device2, colors: color2, deviceAmount: 2)
        }
        .padding(4)
    }
}

