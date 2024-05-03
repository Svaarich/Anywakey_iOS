import SwiftUI

struct DeviceInfoView: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @FocusState private var isFocused: FocusedStates?
    
    // Edit / Delete
    @State private var isEditing: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var dismissView: Bool = false
    @State private var showCopiedView: Bool = false
    @State private var showWrongInput: Bool = false
    
    // Device components
    @State private var name: String
    @State private var BroadcastAddr: String
    @State private var MAC: String
    @State private var Port: String
    
    @State private var device: Device
    
    @State private var animateButton: Bool = false
    @State private var animateWrongInput: Bool = false
    @Binding var showDeleteCancelation: Bool
    
    init(device: Device, showDeleteCancelation: Binding<Bool>) {
        _name = State(initialValue: device.name)
        _BroadcastAddr = State(initialValue: device.BroadcastAddr)
        _MAC = State(initialValue: device.MAC)
        _Port = State(initialValue: device.Port)
        _device = State(initialValue: device)
        self._showDeleteCancelation = showDeleteCancelation
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack(spacing: 16) {
                    HStack {
                        title
                        Spacer()
                    }
                    
                    deviceCard
                        .animation(.easeInOut(duration: 1).repeatForever(), value: animateWrongInput)
                        .animation(.spring, value: isFocused)
                        .animation(.bouncy, value: [name, MAC, BroadcastAddr, Port])
                    HStack {
                        // Delete button
                        deleteButton
                        
                        // Copy button
                        copyButton
                        
                        // Edit button
                        editButton
                    }
                    
                    if !isEditing {
                        BigBootButton(device: device)
                    }
                    Spacer()
                }
                .padding()
                CopiedNotificationView()
                    .opacity(showCopiedView ? 1.0 : 0)
                    .animation(.spring, value: showCopiedView)
                WrongInput()
                    .opacity(showWrongInput ? 1.0 : 0)
                    .animation(.spring, value: showWrongInput)
            }
        }
        
        // delete confirmation sheet
        .sheet(isPresented: $showDeleteAlert) {
            DeleteDeviceSheet(showDeleteCancelation: $showDeleteCancelation, device: device, dismissParentView: $dismissView)
                .presentationDetents([.medium])
        }
        
        .scrollIndicators(.hidden)
        .ignoresSafeArea(.keyboard)
        
        // navigation bar setting
        .navigationBarBackButtonHidden(isEditing)
        .navigationTitle("Information")
        .navigationBarTitleDisplayMode(.inline)
        
        .onChange(of: dismissView) { value in
            if value {
                dismiss()
            }
        }
    }
}

extension DeviceInfoView {
    
    // MARK: Emum for focused states
    
    private enum FocusedStates: Hashable {
        case name
        case adress
        case mac
        case port
    }
}

extension DeviceInfoView {
    
    // MARK: PROPERTIES
    
    private var deviceCard: some View {
        VStack {
            
            // name
            nameField
            
            // address
            addressField
            
            // MAC
            macField
                .keyboardType(.alphabet)
                .autocorrectionDisabled()
            
            // port
            portField
            
        }
        .disabled(!isEditing)
        
        .padding()
        .padding(.top, 8)
        
        .background(Color.gray.opacity(colorScheme == .dark ? 0.2 : 0.1))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        
        .overlay {
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(lineWidth: 1)
                .foregroundStyle(.blue.opacity(isEditing ? 1 : 0))
        }
    }
    
    private var title: some View {
        HStack {
            Text(name.isEmpty ? "[No name]" : name)
                .lineLimit(1)
            if device.isPinned {
                Image(systemName: "star.fill")
                    .font(.headline)
                    .foregroundStyle(DrawingConstants.starColor)
                    .shadow(color: DrawingConstants.starColor.opacity(0.4), radius: 7)
            }
        }
        .font(.title)
        .fontWeight(.bold)
        .padding(.leading)
    }
    
    
    // nameField
    private var nameField: some View {
        VStack(alignment: .leading) {
            textFieldBackground
                .onTapGesture {
                    isFocused = .name
                }
                .overlay {
                    TextField("Device name", text: $name)
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
            Text("Device Name")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.leading, 8)
        }
    }
    
    // addressField
    private var addressField: some View {
        VStack(alignment: .leading) {
            textFieldBackground
                .onTapGesture {
                    isFocused = .adress
                }
                .overlay {
                    TextField("IP / Broadcast Address", text: $BroadcastAddr)
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
            HStack {
                Text("IP / Broadcast Address")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Spacer()
                if !BroadcastAddr.isValidAdress() {
                    wrongInput
                }
            }
            .padding(.horizontal, 8)
        }
    }
    
    // MACField
    private var macField: some View {
        VStack(alignment: .leading) {
            textFieldBackground
                .onTapGesture {
                    isFocused = .mac
                }
                .overlay {
                    TextField("MAC Address", text: $MAC)
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
            HStack {
                Text("MAC Address")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Spacer()
                if !MAC.isValidMAC() {
                    wrongInput
                }
            }
            .padding(.horizontal, 8)
        }
    }
    
    // portField
    private var portField: some View {
        VStack(alignment: .leading) {
            textFieldBackground
                .onTapGesture {
                    isFocused = .port
                }
                .overlay {
                    TextField("Port", text: $Port)
                        .focused($isFocused, equals: .port)
                        .padding()
                        .keyboardType(.numberPad)
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
            HStack {
                Text("Port")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                Spacer()
                if !Port.isValidPort() {
                    wrongInput
                }
            }
            .padding(.horizontal, 8)
        }
    }
    
    // Delete button
    private var deleteButton: some View {
        Button {
            withAnimation {
                showDeleteAlert.toggle()
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: "trash.fill")
                    .foregroundStyle(.red)
                Text("Delete")
                    .foregroundStyle(Color.red.opacity(0.7))
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(colorScheme == .dark ? 0.2 : 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
    
    // Copy button
    private var copyButton: some View {
        Button {
            device.exportJSON()
            showCopiedView = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showCopiedView = false
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: "doc.on.doc")
                Text("Copy")
                    .foregroundStyle(.gray)
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(colorScheme == .dark ? 0.2 : 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
    
    // Edit button
    private var editButton: some View {
        Button {
            withAnimation {
                isEditing.toggle()
                if !isEditing {
                    dataService.updateDevice(
                        oldDevice: device,
                        newDevice: Device(
                            name: name,
                            MAC: MAC,
                            BroadcastAddr: BroadcastAddr,
                            Port: Port,
                            isPinned: device.isPinned,
                            id: device.id))
                    device = Device(
                        name: name,
                        MAC: MAC,
                        BroadcastAddr: BroadcastAddr,
                        Port: Port,
                        isPinned: device.isPinned,
                        id: device.id)
                }
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: isEditing ? "checkmark" : "square.and.pencil")
                Text(isEditing ? "Save" : "Edit")
                    .foregroundStyle(.gray)
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(colorScheme == .dark ? 0.2 : 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15))
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
    
    private var wrongInput: some View {
        HStack(spacing : 4) {
            Text("wrong value")
                .font(.footnote)
                .foregroundStyle(.tertiary)
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(animateWrongInput ? .red : Color.custom.starColor)
                .font(.footnote)
        }
        .onAppear {
            animateWrongInput = true
        }
    }
    
    private struct DrawingConstants {
        static let starColor = Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
        static let onlineColor: Color = .green
        static let offlineColor: Color = .pink
        
        static let imageSize: CGFloat = 24.0
        static let fontSize: CGFloat = 15.0
    }
    
    private func startAnimate() {
        animateButton = true
        animateWrongInput = true
    }
}

#Preview {
    @EnvironmentObject var dataService: DeviceDataService
    return NavigationStack {
        DeviceInfoView(device: Device(name: "test name", MAC: "11:11", BroadcastAddr: "1.1.1.1", Port: "009"), showDeleteCancelation: .constant(false))
    }
}
