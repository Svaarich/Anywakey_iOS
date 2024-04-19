
import SwiftUI

struct CancelDeleteView: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    
    @State private var counter: Int = 5
    @Binding var showView: Bool
    @State var animate: CGFloat = 1.0
    
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
                        .trim(from: 0.0, to: animate)
                        .rotation(.degrees(-90))
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
//            withAnimation(.spring(duration: 5.5)) {
//                
//            }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                withAnimation {
                    animate -= 0.20
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

#Preview {
    CancelDeleteView(showView: .constant(true))
}
