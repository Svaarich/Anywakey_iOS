import SwiftUI

struct AddDeviceView: View {
    
    @EnvironmentObject var computer: Computer
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var name: String = ""
    @State private var BroadcastAddr: String = ""
    @State private var MAC: String = ""
    @State private var Port: String = ""
    
    @State private var isCorrectPort: Bool = true
    
    @Binding var isPresented: Bool
    
    @FocusState private var isFocused
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                title
                Spacer()
                dismissButton
            }
            textFieldsStack
            saveButton
                .padding(.top, 8)
                .ignoresSafeArea(.all)
            Spacer()
        }
        // keyboard settings
        .autocorrectionDisabled()
        .keyboardType(.alphabet)
        
        // style
        .font(.footnote)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        
        // swipe down gesture, closes the view
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded { value in
                if value.translation.height > 0 {
                    dismiss()
                }
            })
        
        .onAppear {
            // Highlight first Textfield with device name
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isFocused = true
            }
        }
        
        .onChange(of: Port) { _ in
            isCorrectPortInput()
        }
    }
    
    
    //MARK: isCorrect input func
    // Port check
    private func isCorrectPortInput() {
        if Port.isEmpty {
            isCorrectPort = true
        } else {
            if let _ = UInt16(Port) {
                isCorrectPort = true
            } else {
                isCorrectPort = false
            }
        }
    }
    
    private func dismiss() {
        withAnimation {
            isFocused = false
        }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                isPresented = false
            }
        }
    }
    
    
    //MARK: Title (device name)
    private var title: some View {
        Text("Add new Device")
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
            .padding(.trailing, 8)
    }
    
    
    //MARK: Dismiss button
    private var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.caption)
                .fontWeight(.semibold)
                .padding(6)
                .background(.gray.opacity(0.2))
                .clipShape(Circle())
        }
    }
    
    
    //MARK: TextFields
    private var textFieldsStack: some View {
        VStack(alignment: .leading, spacing: 8) {
            CustomTextField(
                label: "Device Name",
                text: $name,
                isCorrectInput: true)
                .focused($isFocused)
            Text("Device name")
                .padding(.horizontal, 8)
            
            CustomTextField(
                label: "IP / Broadcast Address",
                text: $BroadcastAddr,
                isCorrectInput: true)
            Text("IPv4(e.g. 192.168.0.123) or DNS name for the host.")
                .padding(.horizontal, 8)
            
            CustomTextField(
                label: "MAC Address",
                text: $MAC,
                isCorrectInput: true)
            Text("(e.g. 00:11:22:AA:BB:CC)")
                .padding(.horizontal, 8)
            
            CustomTextField(
                label: "Port",
                text: $Port,
                isCorrectInput: isCorrectPort)
            Text("Typically sent to port 7 or 9")
                .padding(.horizontal, 8)
                .keyboardType(.numberPad)
        }
    }
    
    
    //MARK: Save button
    private var saveButton: some View {
        Button {
            computer.add(newDevice: Device(
                name: name,
                MAC: MAC,
                BroadcastAddr: BroadcastAddr,
                Port: Port))
            
            dismiss()
        } label: {
            Text("Save")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(8)
                .padding(.horizontal)
//                .background(.gray.opacity(0.2))
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: .blue.opacity(0.2), radius: 15)
        }
    }
}

#Preview {
    @State var isPresented: Bool = true
    return AddDeviceView(isPresented: $isPresented)
}
