
import UIKit
import SwiftUI

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        if let itemProviders = (extensionContext!.inputItems.first as? NSExtensionItem)?.attachments {
            let hostingView = UIHostingController(rootView: ShareView(extensionContext: extensionContext, itemProviders: itemProviders))
            hostingView.view.frame = view.frame
            view.addSubview(hostingView.view)
        }
    }
}

fileprivate struct ShareView: View {
    
    @ObservedObject var svDataService: SVDataService = SVDataService()
    
    var extensionContext: NSExtensionContext?
    var itemProviders: [NSItemProvider]
    
    var body: some View {
        VStack(spacing: 16) {
            header
                .padding(.horizontal)
            ScrollView {
                correctEntryView
                    .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .onAppear {
            svDataService.extractDevices(extensionContext, itemProviders)
        }
    }
    
    private var header: some View {
        VStack(spacing: 0) {
            if devices.isEmpty {
                Text("Wrong input")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Button("close") {
                            dismiss()
                        }
                        .tint(.red)
                    }
            } else {
                correctEntryView
            }
        }
        .padding()
        .onAppear(perform: extractDevices)
    }
    
    private var correctEntryView: some View {
        VStack(spacing: 16) {
            Text("Choose devices")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                }
            if !devices.isEmpty {
                ForEach(devices) { device in
                    HStack {
                        Text(device.name)
                        Spacer()
                        Image(systemName: "power")
                    }
                }
                Button {
                    // do action
                } label: {
                    Text("Import")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                }
                .padding(.bottom, 64)
            }
        }
    }
    
    private func dismiss() {
        extensionContext?.completeRequest(returningItems: [])
    }
}
