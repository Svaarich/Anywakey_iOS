
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
            if svDataService.devices.isEmpty {
                VStack(spacing: 16) {
                    Text("Error")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .leading) {
                            Button("Close", action: dismiss)
                                .tint(.primary)
                        }
                    Group {
                        Text("Wrong input.")
                        Text("Please use correct configuraion file.")
                    }
                    .foregroundStyle(.secondary)
                }
            } else {
                Text("Choose devices")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Button("Cancel", action: dismiss)
                            .tint(.primary)
                    }
            }
        }
    }
    
    private var correctEntryView: some View {
        LazyVStack(spacing: 16) {
            if !svDataService.devices.isEmpty {
                ForEach(svDataService.devices) { item in
                    HStack {
                        Image(systemName: item.isPinned ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(item.isPinned ? .blue : .primary)
                        Text(item.name)
                            .lineLimit(1)
                        Spacer()
                    }
                    .font(.title3)
                    .onTapGesture {
                        for device in svDataService.devices {
                            if device.id == item.id {
                                svDataService.devices[svDataService.devices.firstIndex(of: device)!] = device.pinToggle()
                            }
                        }
                    }
                }
                Button {
                    svDataService.saveUserDefaults()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        dismiss()
                    }
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
