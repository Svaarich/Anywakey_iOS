import SwiftUI

struct AppInfoView: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("tester") var isTester = false
    
    @State private var showDeleteConfirmation: Bool = false
    @State private var showFileImporter: Bool = false
    
    private let linkTreeURL = "https://linktr.ee/svarychevskyi"
    private let gitHubURL = "https://github.com/Svaarich"
    private let gitHubRepoURL = "https://github.com/Svaarich/LANWakeUp-IOS"
    private let bugReportURL = "https://github.com/Svaarich/LANWakeUp-IOS/issues/new"
    
    var body: some View {
        ScrollView {
            VStack {
                
                icon
                    .padding(.top)
                
                header
                
                // links
                VStack(spacing: 0) {
                    
                    gitHubRepoButton
                    
                    Divider()
                    
                    gitHubButton
                    
                    Divider()
                    
                    linkTreeButton
                    
                    Divider()
                    
                    NavLinkButton(text: "Alarm", image: Image(systemName: "power"), color: .red) {
                        AlarmView()
                    }
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom)
                
                VStack(spacing: 0) {
                    
                    bugReportButton
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom)
                
                // buttons
                if isTester {
                    VStack(spacing: 0) {
                        
                        testerAddButton
                        
                        Divider()
                        
                        testerDeleteButton
                        
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom)
                }
                
                VStack(spacing: 0) {
                    
                    if #available(iOS 17.0, *) {
                        widgetSettingsButton
                        Divider()
                    }
                    
                    telegramNotifierButton
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom)
                
                VStack(spacing: 0) {
                    
                    exportFileButton
                    
                    Divider()
                    
                    importConfigButton
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom)
                
                version
                    .padding(.top)
            }
            .padding(.horizontal, 14)
        }
        .background {
            if colorScheme == .light {
                Color.gray.opacity(0.1).ignoresSafeArea()
            }
        }
        
        .navigationTitle("App Information")
        .navigationBarTitleDisplayMode(.inline)
        
        .confirmationDialog("Delete all devices?", isPresented: $showDeleteConfirmation) {
            Button(role: .destructive) {
                dataService.allDevices = []
            } label: {
                Text("Delete")
            }
            Button(role: .cancel) {
                
            } label: {
                Text("Cancel")
            }
        }
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.text]) { result in
            do {
                let fileUrl = try result.get()
                if fileUrl.startAccessingSecurityScopedResource() {
                    dataService.importConfig(from: fileUrl)
                }
                fileUrl.stopAccessingSecurityScopedResource()
            } catch {
                print("Error file reading. \(error)")
            }
        }
    }
}

extension AppInfoView {
    
    // MARK: PROPERTIES
    
    private var icon: some View {
        Image(systemName: "togglepower")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.white)
            .frame(width: 150, height: 150)
            .padding(20)
            .background(Color(red: 25/255, green: 25/255, blue: 25/255))
            .clipShape(RoundedRectangle(cornerRadius: 35))
            .overlay {
                Circle()
                    .foregroundStyle(.green)
                    .frame(width: 15)
                    .offset(x: 68, y: 68)
            }
    }
    
    private var version: some View {
        VStack(alignment: .center) {
            Text("Anywakey Mobile App")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.primary)
            Text("Version: \(Bundle.main.releaseVersionNumber ?? "")")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
            if isTester {
                Text("Build: \(Bundle.main.buildVersionNumber ?? "")")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .onTapGesture(count: 10) {
            withAnimation(.smooth(duration: 0.3)) {
                isTester.toggle()
            }
        }
    }
    
    private var header: some View {
        VStack {
            Text("Anywakey")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
        }
    }
    
    // For testers
    
    private var testerDeleteButton: some View {
        AppInfoButton(
            text: "Delete all devices",
            image: Image(systemName: "trash.fill"),
            color: .red) {
                showDeleteConfirmation.toggle()
            }
            .disabled(dataService.allDevices.isEmpty)
    }
    
    private var testerAddButton: some View {
        AppInfoButton(
            text: "Add test devices",
            image: Image(systemName: "text.badge.plus"),
            color: .blue) {
                dataService.allDevices.append(contentsOf: [
                    Device(name: "Correct online",
                           MAC: "AA:AA:AA:AA:AA:AA",
                           BroadcastAddr: "1.1.1.1",
                           Port: "23"),
                    Device(name: "Incorrect online",
                           MAC: "AA:AA:AA:AA:AA:AM",
                           BroadcastAddr: "1.1.1.1",
                           Port: "98765"),
                    Device(name: "Correct online + pinned",
                           MAC: "AA:AA:AA:AA:AA:AA",
                           BroadcastAddr: "1.1.1.1",
                           Port: "23",
                           isPinned: true),
                    Device(name: "Incorrect online + pinned",
                           MAC: "AA:AA:AA:AA:AA:AM",
                           BroadcastAddr: "1.1.1.1",
                           Port: "98765",
                           isPinned: true)
                ])
            }
        
    }
    
    // For user
    private var linkTreeButton: some View {
        LinkButton(
            stringURL: linkTreeURL,
            text: "Linktree",
            image: Image(systemName: "tree.fill"),
            color: .green)
    }
    
    private var gitHubButton: some View {
        LinkButton(
            stringURL: gitHubURL,
            text: "GitHub",
            image: Image("gitLogo"),
            color: Color(red: 20/255, green: 20/255, blue: 20/255))
    }
    
    private var gitHubRepoButton: some View {
        LinkButton(
            stringURL: gitHubRepoURL,
            text: "Application sources",
            image: Image(systemName: "togglepower"),
            color: .black)
    }
    
    private var bugReportButton: some View {
        LinkButton(
            stringURL: bugReportURL,
            text: "Issue / Bug report",
            image: Image(systemName: "ant.fill"),
            color: .red)
    }
    
    private var widgetSettingsButton: some View {
        NavLinkButton(
            text: "Widget setting",
            image: Image(systemName: "square.tophalf.filled"),
            color: .indigo) {
                WidgetSettingsView()
        }
    }
    
    private var telegramNotifierButton: some View {
        let color = Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
        return NavLinkButton(
            text: "Telegram notifications",
            image: Image(systemName: "paperplane.circle.fill"),
            color: color) {
                BotConfigurationView()
            }
    }
    
    private var exportFileButton: some View {
        ShareButton(
            text: "Share configuration file",
            image: Image(systemName: "square.and.arrow.up.fill"),
            color: .blue,
            imageColor: .white,
            configURL: ShareManager.instance.share(config: dataService.getConfig()))
    }
    
    private var importConfigButton: some View {
        AppInfoButton(
            text: "Import configuration file",
            image: Image(systemName: "square.and.arrow.down.fill"),
            color: .blue,
            imageColor: .white) {
                showFileImporter.toggle()
            }
    }
}
