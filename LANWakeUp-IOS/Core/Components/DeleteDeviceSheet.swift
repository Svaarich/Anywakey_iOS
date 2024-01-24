
import SwiftUI

struct DeleteDeviceSheet: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    @Environment(\.dismiss) var dismiss
    
    let device: Device
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "trash")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.red)
                .frame(width: 130, height: 130)
                .padding(32)
                .background(.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .shadow(color: Color.red, radius: 50)
            Spacer()
            Text(device.name.isEmpty ? "No Name" : device.name)
                .lineLimit(1)
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Text("Are you sure you want to delete device?")
            Spacer()
            HStack {
                // delete
                Button {
                    dataService.delete(device: device)
                    dismiss()
                } label: {
                    Text("Delete")
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.red)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .background(Color.secondary.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                // cancel
                Button(role: .cancel){
                    dismiss()
                } label: {
                    Text("Cancel")
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        }
        .padding()
    }
}

#Preview {
    DeleteDeviceSheet(device: Device(name: "test", MAC: "1", BroadcastAddr: "1", Port: "1"))
}
