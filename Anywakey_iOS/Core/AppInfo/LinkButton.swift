
import SwiftUI

struct LinkButton: View {
    
    private let url: URL
    private let text: String
    private let image: Image
    private let color: Color
    private let imageColor: Color
    
    init(stringURL: String, text: String, image: Image, color: Color, imageColor: Color = .white) {
        self.url = URL(string: stringURL)!
        self.text = text
        self.image = image
        self.color = color
        self.imageColor = imageColor
    }
    
    var body: some View {
        Link(destination: url) {
            HStack {
                image
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(imageColor)
                    .padding(5)
                    .frame(width: 30, height: 30)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(color)
                    }
                Text(text)
                    .padding(.leading, 8)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 0.1)
            .tint(.primary)
        }
    }
}
