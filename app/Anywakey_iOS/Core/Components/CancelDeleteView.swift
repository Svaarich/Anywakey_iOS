
import SwiftUI

struct CancelDeleteView: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    
    @State private var counter: Int = 5
    @Binding var showView: Bool
    @State private var animate: CGFloat = 1.0
    
    var body: some View {
        HStack {
            Text("\(counter < 0 ? 0 : counter)")
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
                        .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        .foregroundStyle(.primary)
                        .background {
                            Circle()
                                .stroke(lineWidth: 2)
                                .foregroundStyle(.primary.opacity(0.2))
                        }
                }
            Text("Device deleted.")
                .foregroundStyle(.primary)
            Spacer()
            Button {
                // cancel delete action
                withAnimation(.smooth(duration: 0.3)) {
                    dataService.allDevices.insert(dataService.lastDeletedDevice, at: 0)
                    showView = false
                }
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
                withAnimation(.smooth(duration: 0.3)) {
                    animate -= 0.20
                    counter -= 1
                }
            }
        }
        .onChange(of: counter) { _ in
            if counter < 0 {
                withAnimation(.smooth(duration: 0.3)) {
                    showView = false
                }
            }
        }
        .onChange(of: dataService.lastDeletedDevice) { _ in
            counter = 5
            animate = 1.0
        }
    }
}
