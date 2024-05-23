
import SwiftUI


struct Tile: View {
    
    let colors: GradientColor
    let height: CGFloat
    
    var body: some View {
        tile
    }
    
    private var tile: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .foregroundStyle(LinearGradient(
                    colors: colors.color,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
                .frame(maxHeight: height)
        }
        .overlay {
            VStack {
                Text("Tap to edit")
                    .foregroundStyle(.white)
                    .font(Font.system(size: 18))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Image(systemName: "power")
                    .foregroundStyle(.white)
                    .font(Font.system(size: 18))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .opacity(height == .infinity ? 1.0 : 0)
            .padding(16)
        }
    }
}

#Preview {
    Tile(colors: Color.widget.green, height: .infinity)
}
