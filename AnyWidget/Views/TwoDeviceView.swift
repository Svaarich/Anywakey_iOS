
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
            WidgetTile(device: device1, colors: [Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1))])
            //device 2
            WidgetTile(device: device2, colors: [Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))])
        }
        .padding(4)

    }
}

