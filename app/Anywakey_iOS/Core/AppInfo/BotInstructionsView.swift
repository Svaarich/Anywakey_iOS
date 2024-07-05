
import SwiftUI

struct BotInstructionsView: View {
    
    @State private var message: String = "My computer is awake!"
    @State private var token: String = ""
    @State private var isCopied: Bool = false
    
    
    // Colors
    private var tokenColor = Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
    private var tokenColorText = Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
    
    private var messageColorText = Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
    private var messageColor = Color(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1))
    
    private var docsLink: String = "https://github.com/Svaarich/Anywakey_iOS/tree/main/docs"
    
    private var config: String {
        return
                """
                chcp 65001
                curl -s -X POST https://api.telegram.org/bot\(token)/sendMessage -d chat_id=338226829 -d text="\(message)"
                """
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                description
                configuration
                    .padding(.bottom, 8)
               result
                VStack(spacing: 0) {
                    
                    shareButton
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.top)
                
                VStack(spacing: 0) {
                    
                    instructions
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.top)
                Spacer()
            }
            .padding()
            .navigationTitle("Notifier")
        }
    }
    
    private var instructions: some View {
        LinkButton(
            stringURL: docsLink,
            text: "Instructions",
            image: Image(systemName: "doc.plaintext"),
            color: .indigo)
    }
    
    private var shareButton: some View {
        ShareButton(
            text: "Export configuration file",
            image: Image(systemName: "arrow.up.doc.fill"),
            color: .blue,
            configURL: ShareManager.instance.share(botConfig: config))
    }
}

extension BotInstructionsView {
    
    // MARK: PROPERTIES
    
    private var description: some View {
        Text("Use Telegram bot API to know when the computer is started.")
    }
    
    private var configuration: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Header
            Text("Configuration")
                .font(.headline)
                .padding(.top, 8)
            
            // Telegram bot token input
            HStack {
                TextField("Token", text: $token)
                    .padding(8)
                    .padding(.horizontal, 8)
                Button {
                    token = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.gray.opacity(0.5))
                        .padding(.trailing, 8)
                }
            }
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading) {
                Text("Telegram bot token")
                Text("(e.g 123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.leading, 8)
            
            // Message input
            HStack {
                TextField("Message", text: $message)
                    .padding(8)
                    .padding(.horizontal, 8)
                Button {
                    message = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.gray.opacity(0.5))
                        .padding(.trailing, 8)
                }
            }
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            Text("Message (e.g \"Home computer is awake!\")")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.leading, 8)
        }
    }
    
    private var result: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            // Header
            Text("Result")
                .font(.headline)
            
            // Code section
            VStack(alignment: .leading, spacing: 6) {
                
                // Default code
                Text("chcp 65001")
                Text("curl -s -X POST")
                Text("https://api.telegram.org/")
                    .tint(.secondary)
                
                // Telegram token
                Text(token.isEmpty ? "Space for Telegram bot token" : token)
                    .foregroundStyle(tokenColorText)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(5)
                    .padding(.leading, 8)
                    .background(tokenColor.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(alignment: .leading) {
                        UnevenRoundedRectangle(
                            topLeadingRadius: 8,
                            bottomLeadingRadius: 8,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 0)
                        .frame(width: 8)
                        .foregroundStyle(tokenColor)
                    }
                
                // Default code
                Text("sendMessage -d chat_id=338226829")
                
                // Message
                Text(message.isEmpty ? "Space for notification text" : "text=\"\(message)\"")
                    .foregroundStyle(messageColorText)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(5)
                    .padding(.leading, 8)
                    .background(messageColor.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(alignment: .leading) {
                        UnevenRoundedRectangle(
                            topLeadingRadius: 8,
                            bottomLeadingRadius: 8,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 0)
                        .frame(width: 8)
                        .foregroundStyle(messageColor)
                    }
            }
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.leading)
            .padding()
            // leave space for bar
            .padding(.top, 22)
            .font(Font.system(size: 13, design: .monospaced))
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // background
            .background {
                codeBlockBackground
            }
        }
    }
    
    // Code block backgroun
    private var codeBlockBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color.gray.opacity(0.2))
                .overlay(alignment: .top) {
                    // Header
                    Text("notifier.bat")
                        .font(Font.system(size: 16, design: .monospaced))
                        .foregroundStyle(.primary.opacity(0.75))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    // Bar
                    UnevenRoundedRectangle(
                        topLeadingRadius: 20,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 20)
                    .frame(height: 28)
                    .foregroundStyle(.gray.opacity(0.1))
                }
            copyButton
                .padding(.top, 22)
        }
    }
    
    // Copy button
    private var copyButton: some View {
        Button {
            UIPasteboard.general.string = config
            withAnimation(.easeInOut(duration: 0.3)) {
                isCopied = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isCopied = false
                }
            }
        } label: {
            Image(systemName: "square.on.square")
                .foregroundColor(Color.gray.opacity(0.8))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
        }
    }
}


#Preview {
    NavigationStack {
        BotInstructionsView()
    }
    .preferredColorScheme(.dark)
    
}
