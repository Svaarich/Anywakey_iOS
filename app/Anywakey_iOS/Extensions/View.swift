import SwiftUI

extension View {
    // Hides keyboard
    public func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
    
    // Using in Bot Configuration View
    public func highlighted(_ textColor: Color, _ backgroundColor: Color) -> some View {
        modifier(HighlightedText(textColor, backgroundColor))
    }
}
