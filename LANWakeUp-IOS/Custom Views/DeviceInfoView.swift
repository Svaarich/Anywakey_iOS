import SwiftUI

struct DeviceInfoView: View {
    
    @EnvironmentObject var computer: Computer
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var isFocused: FocusedStates?
    
    @State var device: Device
    @State private var index: Int = 1
    @State private var isEditing: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                HStack {
                    title
                    Spacer()
                }
                deviceCard
                bootButton
                Spacer()
            }
            .padding()
        }
        
        .scrollIndicators(.hidden)
        .ignoresSafeArea(.keyboard)
        
        .navigationBarBackButtonHidden(isEditing)
        .navigationTitle("Information")
        .navigationBarTitleDisplayMode(.inline)
        
        .animation(.spring, value: isFocused)
        .animation(.bouncy, value: device)
        .onAppear {
            index = getIndexOfDevice()
        }
        .onChange(of: device) { _ in
            computer.listOfDevices[index] = device
        }
        
        // Delete confirmation
        .alert("Are you sure you want to delete '\(device.name)'?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                withAnimation {
                    computer.delete(oldDevice: device)
                }
                dismiss()
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.bouncy) {
                        isEditing.toggle()
                    }
                } label: {
                    if isEditing {
                        Image(systemName: "checkmark")
                    } else {
                        Image(systemName: "pencil")
                    }
                    
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showDeleteAlert.toggle()
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.pink)
                }
            }
        }
    }
    
    private func getIndexOfDevice() -> Int {
        guard let index = computer.listOfDevices.firstIndex(of: device) else { return 0 }
        return index
    }
    
    private var deviceCard: some View {
        VStack {
            // name
            VStack(alignment: .leading) {
                textFieldBackground
                    .onTapGesture {
                        isFocused = .name
                    }
                    .overlay {
                        TextField("Device name", text: $device.name)
                            .focused($isFocused, equals: .name)
                            .padding()
                        RoundedRectangle(cornerRadius: 45 / 2.3)
                            .strokeBorder(lineWidth: 1)
                            .foregroundStyle(.blue)
                            .opacity(isFocused == .name ? 1 : 0)
                            .frame(height: 45)
                            .frame(maxWidth: .infinity)
                    }
                    .overlay(alignment: .trailing) {
                        fingerIcon
                            .opacity(isFocused == .name ? 0 : 1)
                    }
                HStack {
                    Text("Device Name")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.leading, 8)
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(DrawingConstants.starColor)
                        .font(.footnote)
                        .transition(.move(edge: .leading))
                        .opacity(isEditing ? 1 : 0)
                }
                
                // adress
                textFieldBackground
                    .onTapGesture {
                        isFocused = .adress
                    }
                    .overlay {
                        TextField("IP / Broadcast Address", text: $device.BroadcastAddr)
                            .focused($isFocused, equals: .adress)
                            .padding()
                        RoundedRectangle(cornerRadius: 45 / 2.3)
                            .strokeBorder(lineWidth: 1)
                            .foregroundStyle(.blue)
                            .opacity(isFocused == .adress ? 1 : 0)
                            .frame(height: 45)
                            .frame(maxWidth: .infinity)
                    }
                    .overlay(alignment: .trailing) {
                        fingerIcon
                            .opacity(isFocused == .adress ? 0 : 1)
                    }
                Text("IP / Broadcast Address")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                
                
                // MAC
                textFieldBackground
                    .onTapGesture {
                        isFocused = .mac
                    }
                    .overlay {
                        TextField("MAC Address", text: $device.MAC)
                            .focused($isFocused, equals: .mac)
                            .padding()
                        RoundedRectangle(cornerRadius: 45 / 2.3)
                            .strokeBorder(lineWidth: 1)
                            .foregroundStyle(.blue)
                            .opacity(isFocused == .mac ? 1 : 0)
                            .frame(height: 45)
                            .frame(maxWidth: .infinity)
                    }
                    .overlay(alignment: .trailing) {
                        fingerIcon
                            .opacity(isFocused == .mac ? 0 : 1)
                    }
                
                Text("MAC Address")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                
                
                // port
                textFieldBackground
                    .onTapGesture {
                        isFocused = .port
                    }
                    .overlay {
                        TextField("Port", text: $device.Port)
                            .focused($isFocused, equals: .port)
                            .padding()
                        RoundedRectangle(cornerRadius: 45 / 2.3)
                            .strokeBorder(lineWidth: 1)
                            .foregroundStyle(.blue)
                            .opacity(isFocused == .port ? 1 : 0)
                            .frame(height: 45)
                            .frame(maxWidth: .infinity)
                    }
                    .overlay(alignment: .trailing) {
                        fingerIcon
                            .opacity(isFocused == .port ? 0 : 1)
                    }
                Text("Port")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                
            }
            .padding()
            .padding(.top, 8)
            .background(.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .disabled(!isEditing)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(lineWidth: isEditing ? 1 : 3)
                .foregroundStyle(.blue.opacity(isEditing ? 1 : 0))
        }
    }
    
    private var title: some View {
        HStack {
            Text(device.name.isEmpty ? "[No name]" : device.name)
                .lineLimit(1)
            if device.isPinned {
                Image(systemName: "star.fill")
                    .font(.headline)
                    .foregroundStyle(DrawingConstants.starColor)
                    .shadow(color: DrawingConstants.starColor.opacity(0.4), radius: 7)
            }
        }
        .padding(.leading)
        .font(.title)
        .fontWeight(.bold)
    }
    
    private var bootButton: some View {
        Button {
             // _ = computer.boot(device: device)
        } label: {
            Text("Boot button")
        }
    }
    
    private var fingerIcon: some View {
        Image(systemName: "hand.point.up.left.fill")
            .padding(.trailing)
            .foregroundStyle(.quaternary)
            .font(.headline)
            .transition(.move(edge: .leading))
            .opacity(isEditing ? 1 : 0)
    }
    
    private var textFieldBackground: some View {
        RoundedRectangle(cornerRadius: 45 / 2.3)
            .frame(height: 45)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.quinary)
    }
    
    private struct DrawingConstants {
        static let starColor = Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
        static let onlineColor: Color = .green
        static let offlineColor: Color = .pink
        
        static let imageSize: CGFloat = 24.0
        static let fontSize: CGFloat = 15.0
    }
}

extension DeviceInfoView {
    // Emum for focused states
    private enum FocusedStates: Hashable {
        case name
        case adress
        case mac
        case port
    }
}

#Preview {
    @EnvironmentObject var computer: Computer
    return DeviceInfoView(
        computer: _computer, device: Device(name: "Name", MAC: "11:11:11:11:11", BroadcastAddr: "1.1.1.1", Port: "1"))
}


