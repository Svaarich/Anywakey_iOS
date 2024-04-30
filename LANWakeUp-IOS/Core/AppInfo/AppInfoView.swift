import SwiftUI

struct AppInfoView: View {
    
    private let linkTreeURL = "https://linktr.ee/svarychevskyi"
    private let gitHubURL = "https://github.com/Svaarich"
    private let gitHubRepoURL = "https://github.com/Svaarich/LANWakeUp-IOS"
    private let bugReportURL = "https://github.com/Svaarich/LANWakeUp-IOS/issues/new"
    
    var body: some View {
        VStack(spacing: 16) {
            icon
            Text("LANWakeUp")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text("Version 0.0.1")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            List {
                Section {
                    gitHubRepoButton
                    
                    gitHubButton
                    
                    linkTreeButton
                }
                bugReportButton
                
                
                
            }
            .scrollDisabled(true)
            
            Spacer()
        }
        .padding(.vertical)
        
        .navigationTitle("App Information")
        .navigationBarTitleDisplayMode(.inline)
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
            .background(.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 35))
            .overlay {
                Circle()
                    .foregroundStyle(.green)
                    .frame(width: 15)
                    .offset(x: 68, y: 68)
            }
    }
    
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
            image: Image(systemName: "ladybug"),
            color: .red)
    }
}

#Preview {
    AppInfoView()
}
