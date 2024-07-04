
import SwiftUI

struct BotInstructionsView: View {
    
    @State private var message: String = "My PC is ON!"
    @State private var token: String = "123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"
    @State private var isCopied: Bool = false
    
    
    // Colors
    private var tokenColor = Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
    private var tokenColorText = Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
    
    private var messageColorText = Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
    private var messageColor = Color(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1))
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Using Telegram bot API computer is able to send message directly to your chat with the bot.")
            Text("Configuration")
                .font(.title)
                .padding(.top, 6)
            VStack(alignment: .leading) {
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
                .clipShape(Capsule())
                Text("Message(e.g \"Home computer is awake!\")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 8)
            }
            VStack(alignment: .leading) {
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
                .clipShape(Capsule())
                Text("Telegram bot token(e.g 123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 8)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("chcp 65001")
                Text("curl -s -X POST")
                Text("https://api.telegram.org/")
                    .tint(.secondary)
                Text(token)
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
                
                Text("sendMessage -d chat_id=338226829")
                Text("text=\"\(message)\"")
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
            .font(Font.system(size: 13, design: .monospaced))
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.gray.opacity(0.2))
                    Button {
                        UIPasteboard.general.string = ""
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
            Spacer()
        }
        .padding()
        .navigationTitle("Bot Instructions")
    }
}

#Preview {
    NavigationStack {
        BotInstructionsView()
    }
    .preferredColorScheme(.dark)
    
}
