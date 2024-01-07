import SwiftUI

struct LANWakeUpView: View {
    
    @ObservedObject var computer: Computer
    
    @State var isPresentedAddView: Bool = false
    @State var isPresentedInfoView: Bool = false
    @State var showWarning: Bool = false
    @State var refreshStatus: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if computer.listOfDevices.isEmpty {
                    NoDevicesView(isPresented: $isPresentedAddView)
                        .transition(AnyTransition.opacity.animation(.spring))
                } else {
                    List {
                        //MARK: Sections
                        getSections()
                    }
//                    / List settings
                    // refreshable list
                    .refreshable {
                        refreshStatus.toggle()
                    }
                }
                
                if isPresentedAddView {
                    // also working with <overlay>
                    ZStack {
                        AddDeviceView(isPresented: $isPresentedAddView)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.top, 8)
                            .ignoresSafeArea(edges: .bottom)
                        
                    }
                    .zIndex(2)
                    .transition(.move(edge: .bottom))
                }
                
            }
            .onChange(of: computer.listOfDevices) { _ in
                computer.saveUserDefaults()
            }
            
            .ignoresSafeArea(.keyboard)
            
            //MARK: Navigation title
            .navigationTitle("Device List")
            .navigationBarTitleDisplayMode(.inline)
            
            
            //MARK: Animation
            .animation(.default, value: computer.listOfDevices)
            
            
            //MARK: Toolbar items
            .toolbar {
                // Info button
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        AppInfoView()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
                // Refresh status color
//                ToolbarItem(placement: .topBarLeading) {
//                    Button {
//                        refreshStatus.toggle()
//                    } label: {
//                        if refreshStatus {
//                            ProgressView()
//                        } else {
//                            Image(systemName: "arrow.circlepath")
//                        }
//                    }
//                    .disabled(refreshStatus)
//                }
                // Add button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring) {
                            isPresentedAddView = true
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(Font.system(size: DrawingConstants.toolbarItemSize))
                    }
                }
            }
        }
//        .ignoresSafeArea(.keyboard)
        .environmentObject(computer)
        
        
        //MARK: Network connection check
        .onAppear {
            // isConnected to network?
            showWarning = !Network.isConnectedToNetwork()
            computer.fetchUserDefaults()
            
        }
        // No internet connection alert
        //        .alert("No internet connection", isPresented: $showWarning) {
        //                Button("OK", role: .cancel) { }
        //        }
    }
    
    // MARK: FUNCTIONS
    
    // Gives sections depends on pinned and not pinner devices
    private func getSections() -> AnyView {
        switch numberOfSections() {
        case 1: // only pinned devices
            return AnyView(pinnedSection)
        case 2: // only not pinned devices
            return AnyView(devicesSection)
        case 3: // pinned and not pinned devices
            return AnyView(
                Group {
                    pinnedSection
                    devicesSection
                }
            )
        default:
            return AnyView(EmptyView())
        }
    }
    
    // Gives number of sections
    private func numberOfSections() -> Int {
        var pinned: Int = 0
        var notPinned: Int = 0
        
        for device in computer.listOfDevices {
            if device.isPinned {
                pinned = 1
            } else {
                notPinned = 2
            }
        }
        return pinned + notPinned
    }
    
    // MARK: PROPERTIES
    private var pinnedSection: some View {
        Section {
            ForEach(computer.listOfDevices) { device in
                if device.isPinned {
                    NavigationLink {
                        DeviceInfoView(device: device)
                    } label: {
                        DeviceCellView(refreshStatus: $refreshStatus, device: device)
                    }
                }
            }
            .onMove { indices, newOffset in
                computer.listOfDevices.move(fromOffsets: indices, toOffset: newOffset)
            }
        } header: {
            HStack(spacing: 4) {
                Text("Pinned")
                Image(systemName: "star.fill")
                    .foregroundStyle(DrawingConstants.starColor)
                    .padding(.bottom, 4)
            }
        }
    }
    
    private var devicesSection: some View {
        Section {
            ForEach(computer.listOfDevices) { device in
                if !device.isPinned {
                    NavigationLink {
                        DeviceInfoView(device: device)
                    } label: {
                        DeviceCellView(refreshStatus: $refreshStatus, device: device)
                    }
                }
            }
//            .onDelete { indexSet in
//                computer.listOfDevices.remove(atOffsets: indexSet)
//            }
            .onMove { indices, newOffset in
                computer.listOfDevices.move(fromOffsets: indices, toOffset: newOffset)
            }
        } header: {
            HStack(spacing: 4) {
                Text("All Devices")
                Image(systemName: "macbook.and.ipad")
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private struct DrawingConstants {
        static let starColor = Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
        static let toolbarItemSize: CGFloat = 20
        static let sheetSize: CGFloat = 0.5
    }
}

#Preview {
    let computer = Computer()
    return LANWakeUpView(computer: computer)
}
