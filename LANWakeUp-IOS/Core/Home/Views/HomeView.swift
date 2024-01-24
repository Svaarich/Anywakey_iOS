import SwiftUI

struct HomeView: View {
    
    @ObservedObject var dataService: DeviceDataService
    
    @State var isPresentedAddView: Bool = false
    @State var isPresentedInfoView: Bool = false
    @State var showWarning: Bool = false
    @State var refreshStatus: Bool = false
    
    @State var startingOffsetY: CGFloat = UIScreen.main.bounds.height
    @State var currentDragOffsetY: CGFloat = .zero
    @State var endingOffsetY: CGFloat = .zero
    
    var body: some View {
        NavigationStack {
            ZStack {
                if dataService.allDevices.isEmpty {
                    NoDevicesView(isPresented: $isPresentedAddView)
                        .transition(AnyTransition.opacity.animation(.spring))
                } else {
                    List {
                        //MARK: Sections
                        getSections()
                    }
                    // List settings
                    // refreshable list
                    .refreshable {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            refreshStatus.toggle()
                        }
                    }
                }
                
                // Add device view
                AddDeviceView(offset: $endingOffsetY)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .ignoresSafeArea(edges: .bottom)
                
                            .offset(y: startingOffsetY)
                            .offset(y: currentDragOffsetY)
                            .offset(y: endingOffsetY)
                
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        withAnimation(.spring) {
                                            currentDragOffsetY = value.translation.height
                                        }
                                    }
                                    .onEnded { value in
                                        withAnimation(.spring) {
                                            if currentDragOffsetY > 100 {
                                                endingOffsetY = 0
                                            }
                                            currentDragOffsetY = 0
                                        }
                                    }
                            )
                
            }

            .ignoresSafeArea(.keyboard)
            
            //MARK: Navigation title
            .navigationTitle("Device List")
            .navigationBarTitleDisplayMode(.inline)
            
            
            //MARK: Animation
            .animation(.default, value: dataService.allDevices)
            
            
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

                // Add button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring) {
                            endingOffsetY = -startingOffsetY
//                            isPresentedAddView = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        
        //MARK: Network connection check
        .onAppear {
            // isConnected to network?
            showWarning = !Network.isConnectedToNetwork()
            
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
        var pinned: Int = 0 // pined sections
        var notPinned: Int = 0 // not pinned sections
        for device in dataService.allDevices {
            if device.isPinned {
                pinned = 1
            } else {
                notPinned = 2
            }
        }
        return pinned + notPinned // 1 / 2 / 3
    }
    
    // MARK: PROPERTIES
    
    // Pinned section
    private var pinnedSection: some View {
        Section {
            ForEach(dataService.allDevices) { device in
                if device.isPinned {
                    NavigationLink {
                        DeviceInfoView(device: device)
                    } label: {
                        DeviceCellView(refreshStatus: $refreshStatus, device: device)
                    }
                }
            }
            .onMove { indices, newOffset in
                dataService.allDevices.move(fromOffsets: indices, toOffset: newOffset)
            }
        } header: {
            HStack(spacing: 4) {
                Text("Pinned")
                Image(systemName: "star.fill")
                    .foregroundStyle(Color.custom.starColor)
                    .padding(.bottom, 4)
            }
        }
    }
    // Device section
    private var devicesSection: some View {
        Section {
            ForEach(dataService.allDevices) { device in
                if !device.isPinned {
                    NavigationLink {
                        DeviceInfoView(device: device)
                    } label: {
                        DeviceCellView(refreshStatus: $refreshStatus, device: device)
                    }
                }
            }
            .onMove { indices, newOffset in
                dataService.allDevices.move(fromOffsets: indices, toOffset: newOffset)
            }
        } header: {
            HStack(spacing: 4) {
                Text("All Devices")
                Image(systemName: "macbook.and.ipad")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    let dataService = DeviceDataService()
    return HomeView(dataService: dataService)
}
