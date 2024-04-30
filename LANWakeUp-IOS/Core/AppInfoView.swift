import SwiftUI

struct AppInfoView: View {
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "togglepower")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: 150, height: 150)
                .padding(20)
                .background(.black.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 50))
            
            Text("LANWakeUp")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text("Version 0.0.1")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            gitHubButton
            linkTreeButton
            
            Spacer()
        }
        .padding()
        .background(Color.secondary.opacity(0.1).ignoresSafeArea())
        
        
        .navigationTitle("App Information")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private struct DrawingConstants {
        static let linkTreeURL = URL(string: "https://linktr.ee/svarychevskyi")
        static let gitHubURL = URL(string: "https://github.com/Svaarich/LANWakeUp-IOS")
        static let linkTreeColor = Color(#colorLiteral(red: 0, green: 0.466091156, blue: 0.2602820396, alpha: 1))
    }
}

extension AppInfoView {
    
    // MARK: Links
    
    private var linkTreeButton: some View {
        Link(destination: DrawingConstants.linkTreeURL!) {
            HStack {
                Image(systemName: "tree")
                Text("Linktree")
                Spacer()
            }
            .foregroundStyle(.white)
            .fontWeight(.semibold)
            .padding()
            .padding(.horizontal, 8)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(DrawingConstants.linkTreeColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private var gitHubButton: some View {
        Link(destination: DrawingConstants.gitHubURL!) {
            HStack {
                Image("gitLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.white)
                    
                Text("GitHub")
                Spacer()
                
            }
            .foregroundStyle(.white)
            .fontWeight(.semibold)
            .padding()
            .padding(.horizontal, 8)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    AppInfoView()
}
