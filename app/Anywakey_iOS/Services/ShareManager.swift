
import Foundation
import SwiftUI

public class ShareManager {
    
    private init() {}
    
    static let instance = ShareManager()
    
    public func share(botConfig: String) -> URL {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        // bot config url
        let userConfigURL = documentsURL.appendingPathComponent("notifier.bat", conformingTo: .text)
        
        if let data = botConfig.data(using: .utf8) {
            do {
                try data.write(to: userConfigURL)
                print("Successfully wrote to file")
            } catch {
                print("Error writing to file. \(error)")
            }
        }
        return userConfigURL
    }
    
    public func share(config: String) -> URL {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        // config url
        let userConfigURL = documentsURL.appendingPathComponent("anywakey_config.txt", conformingTo: .text)
        
        if let data = config.data(using: .utf8) {
            do {
                try data.write(to: userConfigURL)
                print("Successfully wrote to file")
            } catch {
                print("Error writing to file. \(error)")
            }
        }
        return userConfigURL
    }
}
