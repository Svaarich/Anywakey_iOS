
import SwiftUI

struct CancelDeleteView: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    
    @State private var counter: Int = 5
    @Binding var showView: Bool
    
    var body: some View {
        HStack {
            Text("\(counter)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .contentTransition(.numericText())
                .padding(8)
                .frame(width: 40, height: 25)
                .overlay {
                    Circle()
                        .stroke(lineWidth: 2)
                        .foregroundStyle(.primary)
                }
            Text("Device deleted.")
                .foregroundStyle(.primary)
            Spacer()
            Button {
                // cancel delete action
                dataService.allDevices.insert(dataService.lastDeletedDevice, at: 0)
                showView = false
            } label: {
                Text("Cancel")
            }
            .padding(.trailing)
        }
        .padding(.vertical, 8)
        .padding(4)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.ultraThinMaterial)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                withAnimation {
                    counter -= 1
                }
            }
        }
        .onChange(of: counter) { _ in
            if counter == -1 {
                withAnimation {
                    showView = false
                }
            }
        }
    }
}
//
//#Preview {
//    CancelDeleteView(showView: .constant(true))
//}
