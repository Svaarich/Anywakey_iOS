import SwiftUI

struct DeviceInfoView: View {
    
    @EnvironmentObject var dataService: DeviceDataService
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @FocusState private var isFocused: FocusedStates?
    
    // Edit / Delete
    @State private var isEditing: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    // Device components
    @State private var name: String
    @State private var BroadcastAddr: String
    @State private var MAC: String
    @State private var Port: String
    
    @State private var device: Device
    
    init(device: Device) {
        _name = State(initialValue: device.name)
        _BroadcastAddr = State(initialValue: device.BroadcastAddr)
        _MAC = State(initialValue: device.MAC)
        _Port = State(initialValue: device.Port)
        _device = State(initialValue: device)
    }
    
    var body: some View {
        ScrollView {
                VStack(spacing: 8) {
                    HStack {
                        title
                        Spacer()
                    }
                    deviceCard
                    if !isEditing {
                        bootButton
                            .padding(.top, 8)
                            .transition(.opacity)
                    }
                    
                    Spacer()
                }
                .padding()
                
        }
        // delete confirmation sheet
        .sheet(isPresented: $showDeleteAlert) {
            DeleteDeviceSheet(device: device)
                .presentationDetents([.medium])
        }
        
        .scrollIndicators(.hidden)
        .ignoresSafeArea(.keyboard)
        
        // navigation bar setting
        .navigationBarBackButtonHidden(isEditing)
        .navigationTitle("Information")
        .navigationBarTitleDisplayMode(.inline)
        
        // animation
        .animation(.spring, value: isFocused)
        .animation(.bouncy, value: [name, MAC, BroadcastAddr, Port])
        
        // toolbar items
        .toolbar {
            // Copy button
            ToolbarItem(placement: .topBarTrailing) {
                copyButton
            }
            
            // edit button
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring) {
                        isEditing.toggle()
                    }
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
                } label: {
                    if isEditing {
                        Image(systemName: "checkmark")
                    } else {
                        Image(systemName: "pencil")
                    }
                    
                }
            }
            // delete button
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        showDeleteAlert.toggle()
                    }
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.pink)
                }
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
                        TextField("Port", text: $Port)
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
            .background(Color.gray.opacity(colorScheme == .dark ? 0.2 : 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .disabled(!isEditing)
        }
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
    
    // Copy button
    private var copyButton: some View {
        Button {
            device.exportJSON()
        } label: {
            Image(systemName: "doc.on.doc")
        }
    }
    
    private var bootButton: some View {
        Button {
            _ = Network.instance.boot(device: device)
        } label: {
            Text("Boot device".uppercased())
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(.blue.opacity(colorScheme == .dark ? 0.2 : 0.8))
                .clipShape(RoundedRectangle(cornerRadius: 45 / 2.3))
                .overlay {
                    RoundedRectangle(cornerRadius: 45 / 2.3)
                        .strokeBorder(lineWidth: 1)
                }
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

#Preview {
    @EnvironmentObject var dataService: DeviceDataService
    return NavigationStack {
        DeviceInfoView(device: Device(name: "test name", MAC: "11:11", BroadcastAddr: "1.1.1.1", Port: "009"))
    }
}
