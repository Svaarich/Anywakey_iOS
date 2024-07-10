
import SwiftUI

struct HighlightedText: ViewModifier {
    
    let textColor: Color
    let backgroundColor: Color
    
    init(_ textColor: Color, _ backgroundColor: Color) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    // Highlights text in Bot Configuration View
    func body(content: Content) -> some View {
        content
            .foregroundStyle(textColor)
            .fixedSize(horizontal: false, vertical: true)
            .padding(5)
            .padding(.leading, 8)
            .background(backgroundColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(alignment: .leading) {
                UnevenRoundedRectangle(
                    topLeadingRadius: 8,
                    bottomLeadingRadius: 8,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0)
                .frame(width: 8)
                .foregroundStyle(backgroundColor)
            }
    }
}
