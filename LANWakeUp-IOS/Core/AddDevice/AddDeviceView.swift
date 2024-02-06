import SwiftUI

struct AddDeviceView: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    
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
        
//        .offset(y: startingOffsetY)
//        .offset(y: currentDragOffsetY)
//        .offset(y: endingOffsetY)
//        
        // keyboard settings
        .autocorrectionDisabled()
        .keyboardType(.alphabet)
        
        // style
        .font(.footnote)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        
        .onAppear {
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    isFocused.toggle()
                }
            }
        }
        
        .onChange(of: Port) { _ in
            isCorrectPortInput()
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
    
    // Port input  check
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
    
    // dismiss view
    private func dismiss() {
        hideKeyboard()
        withAnimation(.easeInOut) {
                isPresented = false
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
                text: $BroadcastAddr)
            Text("IPv4(e.g. 192.168.0.123) or DNS name for the host.")
                .padding(.horizontal, 8)
            
            FlexibleTextField(
                label: "MAC Address",
                text: $MAC)
            Text("(e.g. 00:11:22:AA:BB:CC)")
                .padding(.horizontal, 8)
            
            FlexibleTextField(
                label: "Port",
                text: $Port,
                isCorrectInput: isCorrectPort)
            Text("Typically sent to port 7 or 9")
                .padding(.horizontal, 8)
                .keyboardType(.numberPad)
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
