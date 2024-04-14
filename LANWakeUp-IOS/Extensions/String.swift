import SwiftUI

extension String {
    
    // Returns size of Text with specified font
    func sizeOfString(font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size
    }
    
    // Broadcast address validator
    func isValidAdress() -> Bool {
        var sin = sockaddr_in()
        var sin6 = sockaddr_in6()
        
        if self.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {
            // IPv6 peer
            return true
        } else if self.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
            // IPv4 peer
            return true
        }
        return false
    }
    
    // Port validator
    func isValidPort() -> Bool {
        if self.isEmpty {
            return true
        } else {
            if let _ = UInt16(self) {
                return true
            } else {
                return false
            }
        }
    }
}
