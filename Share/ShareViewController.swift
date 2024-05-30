
import UIKit
import SwiftUI

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    private func extractDevices() {
        guard devices.isEmpty else { return }
        DispatchQueue.global(qos: .userInteractive).async {
            for provider in itemProviders {
                let _ = provider.loadDataRepresentation(for: .text) { data, error in
                    let decoder = JSONDecoder()
                    do {
                        devices = try decoder.decode([Device].self, from: data!)
                    } catch {
                        print("Unable to read data. \(error)")
                    }
                }
            }
        }
    }
    
    private func dismiss() {
        extensionContext?.completeRequest(returningItems: [])
    }
}
