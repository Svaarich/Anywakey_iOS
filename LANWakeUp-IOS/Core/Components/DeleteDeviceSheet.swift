
import SwiftUI

/// Delete device confirmation sheet
/// ```
/// Represents sheet with delete device confirmation buttons
/// ```
struct DeleteDeviceSheet: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    @Environment(\.dismiss) var dismiss
    
    @State private var animate: Bool = false
    
    let device: Device
    
    var body: some View {
        VStack {
            Spacer()
            // trash icon
            Image(systemName: "trash")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.red)
                .frame(width: 130, height: 130)
                .padding(32)
                .background(.secondary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .shadow(color: Color.red.opacity(animate ? 1 : 0.3), radius: animate ? 70 : 50)

            Spacer()
            
            // alert description
            Text("Are you sure you want to delete device?")
            Spacer()
            
            // device name
            Text(device.name.isEmpty ? "No Name" : device.name)
                .lineLimit(1)
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            
            // Buttons
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
        
        .onAppear(perform: addAnimation)
    }
    
    // Adds animation
    private func addAnimation() {
        guard !animate else { return }
        withAnimation(
            Animation
                .easeInOut(duration: 1.0)
                .repeatForever()
        ) {
            animate.toggle()
        }
        
    }
}

#Preview {
    DeleteDeviceSheet(device: Device(name: "test", MAC: "1", BroadcastAddr: "1", Port: "1"))
}
