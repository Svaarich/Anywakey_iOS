import SwiftUI

struct FlexibleTextField: View {
    
    @FocusState private var isFocused: Bool
    
    @State private var fieldWidth: CGFloat = 0
    @State private var strokeBorderLineWidth: CGFloat = 2
    
    private var isCorrectInput: Bool
    private var label: String
    private var text: Binding<String>
    
    init(label: String, text: Binding<String>, isCorrectInput: Bool = true) {
        self.text = text
        self.label = label
        self.isCorrectInput = isCorrectInput
    }
    
    var body: some View {
        ZStack {
            HStack {
                background
                    .overlay {
                        focusedFrame
                    }
                    .overlay(alignment: .trailing) {
                        if !text.wrappedValue.isEmpty && isFocused {
                            clearButton
                        }
                    }
                Spacer()
            }
            textField
        }
        
        // animations
        .animation(.default, value: isFocused)
        .animation(.bouncy, value: fieldWidth)
        
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                initTextField(text: text.wrappedValue)
            }
        }
        .onChange(of: text.wrappedValue) { newText in
            initTextField(text: newText)
        }
        .onChange(of: isFocused) { _ in
            initTextField(text: text.wrappedValue)
        }
        .onChange(of: isCorrectInput) { _ in
            if isCorrectInput {
                let impactMed = UINotificationFeedbackGenerator()
                impactMed.notificationOccurred(.error)}
        }
        .onTapGesture {
            isFocused = true
        }
    }
    
    
    // MARK: PROPERTIES
    
    // Clear button
    private var clearButton: some View {
        Button {
            text.wrappedValue = ""
        } label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .opacity(0.3)
                .padding(.trailing)
        }
    }
    
    // TextField background
    private var background: some View {
        RoundedRectangle(cornerRadius: DrawingConstants.fieldHeight / 2.3)
            .foregroundStyle(.gray.opacity(0.15))
            .frame(width: fieldWidth, height: DrawingConstants.fieldHeight)
    }
    
    // Background frame
    private var focusedFrame: some View {
        RoundedRectangle(cornerRadius: DrawingConstants.fieldHeight / 2.3)
            .strokeBorder(lineWidth: 2)
            .foregroundStyle(isCorrectInput ? .blue : .red)
            .opacity(isFocused ? 1 : 0)
            .frame(width: fieldWidth, height: DrawingConstants.fieldHeight)
    }
    
    // Textfield
    private var textField: some View {
        TextField(label, text: text)
            .font(Font(DrawingConstants.font))
            .foregroundStyle(isCorrectInput ? .primary : Color.red.opacity(0.7))
            .padding(.horizontal)
            .textFieldStyle(.plain)
            .focused($isFocused)
            .allowsHitTesting(false)
    }
    
    // MARK: FUNCTIONS
    
    // Get TextField width
    private func initTextField(text: String) {
        fieldWidth = text.sizeOfString(font: DrawingConstants.font).width
        if fieldWidth == 0  {
            fieldWidth = label.sizeOfString(font: DrawingConstants.font).width + DrawingConstants.safeDistance
        } else if !text.isEmpty && isFocused {
            fieldWidth += DrawingConstants.safeDistance + 25
        } else {
            fieldWidth += DrawingConstants.safeDistance
        }
    }
    
    private struct DrawingConstants {
        static let font: UIFont = .systemFont(ofSize: 18)
        static let fieldHeight: CGFloat = 40
        static let safeDistance: CGFloat = 35
    }
}
