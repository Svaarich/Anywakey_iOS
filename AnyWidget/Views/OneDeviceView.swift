
import SwiftUI

struct OneDeviceView: View {
    
    let device: Device
    
    init(devices: [Device]) {
        self.device = devices[0]
    }
    
    var body: some View {
        WidgetTile(device: device, colors: Color.widget.green, deviceAmount: 1)
        .padding(4)
    }
}
