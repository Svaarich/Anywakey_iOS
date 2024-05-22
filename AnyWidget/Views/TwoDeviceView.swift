
import SwiftUI

struct TwoDeviceView: View {
    
    let device1: Device
    let device2: Device
    
    init(devices: [Device]) {
        self.device1 = devices[0]
        self.device2 = devices[1]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // device 1
            WidgetTile(device: device1, colors: Color.widget.blue.color, deviceAmount: 2)
            //device 2
            WidgetTile(device: device2, colors: Color.widget.yellow.color, deviceAmount: 2)
        }
        .padding(4)
    }
}

