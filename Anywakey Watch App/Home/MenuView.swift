
import SwiftUI

struct MenuView: View {
    
    @ObservedObject var dataService = WatchDS()
    
    @State private var rotationAngle = 0.0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("To start PC just press button.")
            Spacer()
            Button {
                withAnimation(.smooth) {
                    rotationAngle -= 360
                }
            } label: {
                HStack {
                    Text("Update devices")
                    Spacer()
                    Image(systemName: "arrow.circlepath")
                        .rotationEffect(.degrees(rotationAngle))
                }
            }
            .buttonBorderShape(.roundedRectangle)
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    MenuView(dataService: WatchDS())
}
