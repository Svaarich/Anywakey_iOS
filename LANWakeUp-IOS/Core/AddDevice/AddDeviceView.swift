import SwiftUI

struct AddDeviceView: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var name: String = ""
    @State private var BroadcastAddr: String = ""
    @State private var MAC: String = ""
    @State private var Port: String = ""
    
    @Binding var isPresented: Bool
    
    @FocusState private var isFocused
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                title
                Spacer()
                HStack {
                    pasteButton
                    dismissButton
                }
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
        .padding()
        .background(.ultraThinMaterial)
        .frame(maxWidth: UIScreen.main.bounds.width)
        
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    isFocused.toggle()
                }
            }
        }
        
        .gesture(
            DragGesture()
                .onEnded { value in
                    withAnimation(.easeInOut) {
                        if value.translation.height > 100 {
                            dismiss()
                        }
                    }
                }
        )
    }
}

extension AddDeviceView {
    
    // MARK: FUNCTIONS
    
    // dismiss view
    private func dismiss() {
        hideKeyboard()
        withAnimation(.default) {
            isPresented = false
        }
    }
    
    // Paste device from UIPasteboard
    private func pasteDevice() {
        guard let data = UIPasteboard.general.string else { return }
        dataService.importDeviceFrom(JSON: data) { device in
            name = device.name
            BroadcastAddr = device.BroadcastAddr
            MAC = device.MAC
            Port = device.Port
        }
    }
    
    // MARK: PROPERTIES
    
    // Title (device name)
    private var title: some View {
        Text("Add new Device")
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
            .padding(.trailing, 8)
    }
    
    // Paste button
    private var pasteButton: some View {
        Button {
            pasteDevice()
        } label: {
            Text("Paste")
                .fontWeight(.semibold)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(.gray.opacity(0.2))
                .clipShape(Capsule())
        }
    }
    
    
    // Dismiss button
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
    
    
    // TextFields
    private var textFieldsStack: some View {
        VStack(alignment: .leading, spacing: 8) {
            FlexibleTextField(
                label: "Device Name",
                text: $name)
                .focused($isFocused)
            Text("Device name")
                .padding(.horizontal, 8)
            
            FlexibleTextField(
                label: "IP / Broadcast Address",
                text: $BroadcastAddr,
                isCorrectInput: BroadcastAddr.isEmpty ? .empty : BroadcastAddr.isValidAdress() ? .valid : .invalid)
            
            Text("IPv4(e.g. 192.168.0.123) or DNS name for the host.")
                .padding(.horizontal, 8)
            
            FlexibleTextField(
                label: "MAC Address",
                text: $MAC)
            .textInputAutocapitalization(.characters)
            Text("(e.g. 00:11:22:AA:BB:CC)")
                .padding(.horizontal, 8)
    
            FlexibleTextField(
                label: "Port",
                text: $Port,
                isCorrectInput: Port.isEmpty ? .empty : Port.isValidPort() ? .valid : .invalid)
            Text("Typically sent to port 7 or 9")
                .padding(.horizontal, 8)
        }
    }
    
    
    // Save button
    private var saveButton: some View {
        Button {
            dataService.add(
                newDevice:
                    Device(name:
                            name, MAC:
                            MAC, BroadcastAddr:
                            BroadcastAddr,
                           Port: Port))
            dismiss()
        } label: {
            Text("Save")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(8)
                .padding(.horizontal)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: .blue.opacity(0.2), radius: 15)
        }
    }
}

#Preview {
    @State var show: Bool = true
    return AddDeviceView(isPresented: $show)
}
