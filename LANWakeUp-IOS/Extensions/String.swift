import SwiftUI

extension String {
    
    // Returns size of Text with specified font
    func sizeOfString(font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size
    }
}
