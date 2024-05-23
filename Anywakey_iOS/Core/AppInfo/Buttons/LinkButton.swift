
import SwiftUI

struct LinkButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    
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
                    .padding(.trailing, 6)
                Text(text)
                Spacer()
                Image(systemName: "chevron.right")
                    .opacity(0.3)
            }
            .tint(.primary)
            .frame(height: 45)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 12)
            .background(colorScheme == .light ? .white : Color.gray.opacity(0.2))
        }
    }
}
