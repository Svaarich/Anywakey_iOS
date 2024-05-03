
import SwiftUI

struct WrongInput: View {
    
    private var frameSize: CGFloat {
        UIScreen.main.bounds.width / 3
    }
    
    var body: some View {
        VStack {
            Image(systemName: "wrongwaysign.fill")
                .font(.largeTitle).padding(.bottom, 4)
                .foregroundStyle(.red)
            Text("Wrong input!")
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
