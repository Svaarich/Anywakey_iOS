
import SwiftUI

extension Color {
    
    static let widget = WidgetColorScheme()
    
}

// Custom set of colors
struct WidgetColorScheme {
    
    let orange: GradientColor = GradientColor(color: [Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)), Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))], description: "Orange")
    let purpule: GradientColor = GradientColor(color: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1))], description: "Purpule")
    let blue: GradientColor = GradientColor(color: [Color(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))], description: "Blue")
    let yellow: GradientColor = GradientColor(color: [Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)), Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))], description: "Yellow")
    let pink: GradientColor = GradientColor(color: [Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)), Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))], description: "Pink")
    let green: GradientColor = GradientColor(color: [Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))], description: "Green")
    
}

struct GradientColor: Identifiable {
    let color: [Color]
    let description: String
    let id: String = UUID().uuidString
}

enum WidgetColor: String {
    case orange
    case purpule
    case blue
    case yellow
    case pink
    case green
}
