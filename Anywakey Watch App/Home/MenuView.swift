
import SwiftUI

struct MenuView: View {
    
    var body: some View {
        Text("To start PC just press button.")
    }
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
