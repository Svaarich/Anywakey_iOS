
import SwiftUI

struct CopiedNotificationView: View {
    
    private var frameSize: CGFloat {
        UIScreen.main.bounds.width / 3
    }
    
    var body: some View {
        VStack {
            Image(systemName: "square.on.square")
                .font(.largeTitle).padding(.bottom, 4)
                .foregroundStyle(.blue)
            Text("COPIED!")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        .frame(width: frameSize, height: frameSize)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(.ultraThickMaterial)
        }
    }
}
