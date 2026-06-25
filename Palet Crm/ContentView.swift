//
//  ContentView.swift
//  Palet Crm
//
//  Created by Yunus Emre Gürlek on 25.06.2026.
//

import SwiftUI

enum NavigationTab: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case projects = "Projects"
    case clients = "Clients"
    case sales = "Sales"
    case reports = "Reports"
    case watch = "Watch"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .dashboard: return "square.grid.2x2.fill"
        case .projects: return "building.2.fill"
        case .clients: return "person.3.fill"
        case .sales: return "turkishlirasign.circle.fill"
        case .reports: return "doc.text.below.ecg.fill"
        case .watch: return "applewatch"
        }
    }
}

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var selectedTab: NavigationTab? = .dashboard
    @State private var searchText = ""
    @State private var showNotifications = false
    @State private var selectedProject: Project?
    
    let data = MockData.shared
    
    var body: some View {
        Group {
            #if os(macOS)
            macOSLayout
            #else
            if sizeClass == .compact {
                iPhoneLayout
            } else {
                iPadLayout
            }
            #endif
        }
        .background(Theme.background.ignoresSafeArea())
        .sheet(item: $selectedProject) { project in
            ProjectDetailView(project: project)
        }
        .alert("Notifications", isPresented: $showNotifications) {
            Button("Dismiss", role: .cancel) {}
        } message: {
            Text("You have 2 pending approvals from Site Manager Savaş Mert.")
        }
    }
    
    // MARK: - Animated Content Container
    private var detailContent: some View {
        detailViewForTab(selectedTab ?? .dashboard)
            .id(selectedTab ?? .dashboard)
            .transition(.opacity)
    }
    
    #if os(iOS)
    // MARK: - iPhone Layout (Floating Bottom Tab Bar)
    private var iPhoneLayout: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Scrollable main content pane
                ScrollView {
                    detailContent
                        .padding(.top, 10)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 95) // Clear room for floating bottom tab bar
                }
                .background(Theme.background.ignoresSafeArea())
                .animation(Theme.fluidSpring, value: selectedTab)
                
                // Floating glass tab bar overlay
                CustomFloatingTabBar(selectedTab: $selectedTab)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Theme.primarySlate)
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Welcome,")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(Theme.textMuted)
                            Text("Yunus Bey")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Theme.textDark)
                        }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text((selectedTab ?? .dashboard).rawValue)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Theme.primarySlate)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNotifications = true
                    } label: {
                        ZStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(Theme.primarySlate)
                            
                            Circle()
                                .fill(Theme.stateRed)
                                .frame(width: 8, height: 8)
                                .offset(x: 5, y: -5)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - iPad Layout (Collapsible Morphing Sidebar)
    private var iPadLayout: some View {
        NavigationSplitView {
            CustomSidebarView(selectedTab: $selectedTab)
        } detail: {
            NavigationStack {
                ScrollView {
                    detailContent
                        .padding(24)
                }
                .background(Theme.background.ignoresSafeArea())
                .animation(Theme.fluidSpring, value: selectedTab)
                .navigationTitle((selectedTab ?? .dashboard).rawValue)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 16) {
                            // Header search box
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Theme.textMuted)
                                TextField("Search contracts, sites...", text: $searchText)
                                    .textFieldStyle(.plain)
                                    .frame(width: 190)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border, lineWidth: 1))
                            
                            Button {
                                showNotifications = true
                            } label: {
                                ZStack {
                                    Image(systemName: "bell.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(Theme.primarySlate)
                                    Circle()
                                        .fill(Theme.stateRed)
                                        .frame(width: 8, height: 8)
                                        .offset(x: 6, y: -6)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
    #endif
    
    // MARK: - macOS Layout (Three Column Layout)
    private var macOSLayout: some View {
        NavigationSplitView {
            CustomSidebarView(selectedTab: $selectedTab)
        } content: {
            middleColumnForTab(selectedTab ?? .dashboard)
        } detail: {
            NavigationStack {
                ScrollView {
                    detailContent
                        .padding(24)
                }
                .background(Theme.background)
                .animation(Theme.fluidSpring, value: selectedTab)
                .navigationTitle((selectedTab ?? .dashboard).rawValue)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack(spacing: 12) {
                            Text("Welcome back, Yunus Bey")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Theme.textDark)
                            
                            Button {
                                showNotifications = true
                            } label: {
                                ZStack {
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(Theme.primarySlate)
                                    Circle()
                                        .fill(Theme.stateRed)
                                        .frame(width: 7, height: 7)
                                        .offset(x: 5, y: -5)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Tab Detail Views Dispatch
    @ViewBuilder
    private func detailViewForTab(_ tab: NavigationTab) -> some View {
        switch tab {
        case .dashboard:
            DashboardMainView(selectedProject: $selectedProject)
        case .projects:
            ProjectsMainPane(selectedProject: $selectedProject)
        case .clients:
            ClientsListView()
        case .sales:
            SalesPipelineView()
        case .reports:
            ReportsMainView()
        case .watch:
            WatchComplicationsView()
        }
    }
    
    // Middle column loader for 3-column macOS structure
    @ViewBuilder
    private func middleColumnForTab(_ tab: NavigationTab) -> some View {
        switch tab {
        case .projects:
            List(data.criticalProjects) { project in
                Button {
                    selectedProject = project
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(project.name)
                            .font(.system(size: 13, weight: .bold))
                        HStack {
                            Text(project.deadline)
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textMuted)
                            Spacer()
                            Text("\(Int(project.progress * 100))%")
                                .font(.system(size: 11, weight: .semibold))
                        }
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Projects List")
        case .clients:
            List(data.clients) { client in
                VStack(alignment: .leading, spacing: 2) {
                    Text(client.name)
                        .font(.system(size: 13, weight: .bold))
                    Text(client.contactPerson)
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                }
                .padding(.vertical, 2)
            }
            .navigationTitle("Client Records")
        default:
            VStack {
                Text("Select item to view details")
                    .foregroundColor(Theme.textMuted)
            }
            .navigationTitle("Quick Look")
        }
    }
}

// MARK: - Custom Floating Bottom Tab Bar
struct CustomFloatingTabBar: View {
    @Binding var selectedTab: NavigationTab?
    @Namespace private var floatingBarNamespace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(NavigationTab.allCases) { tab in
                Button {
                    withAnimation(Theme.fluidSpring) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor((selectedTab ?? .dashboard) == tab ? .white : Theme.textMuted)
                        
                        Text(tab.rawValue)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor((selectedTab ?? .dashboard) == tab ? .white : Theme.textMuted)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        ZStack {
                            if (selectedTab ?? .dashboard) == tab {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Theme.copperGradient)
                                    .matchedGeometryEffect(id: "activeTabHighlight", in: floatingBarNamespace)
                                    .shadow(color: Theme.accentCopper.opacity(0.35), radius: 8, x: 0, y: 4)
                            }
                        }
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(.white.opacity(0.75))
                .background(VisualBlurView())
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.4), lineWidth: 1.2)
        )
        .shadow(color: Theme.primarySlate.opacity(0.06), radius: 18, x: 0, y: 10)
    }
}

// MARK: - Custom Sidebar View for iPad & macOS
struct CustomSidebarView: View {
    @Binding var selectedTab: NavigationTab?
    @Namespace private var sidebarHighlightNamespace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header Branding Section
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Theme.copperGradient)
                        .frame(width: 34, height: 34)
                    Text("P")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("Palet CRM")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Theme.textDark)
                    Text("Construction Suite")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Theme.textMuted)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 16)
            
            // Sidebar selection grid
            ForEach(NavigationTab.allCases) { tab in
                Button {
                    withAnimation(Theme.fluidSpring) {
                        selectedTab = tab
                    }
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor((selectedTab ?? .dashboard) == tab ? .white : Theme.primarySlate)
                        
                        Text(tab.rawValue)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor((selectedTab ?? .dashboard) == tab ? .white : Theme.textDark)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        ZStack {
                            if (selectedTab ?? .dashboard) == tab {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Theme.slateGradient)
                                    .matchedGeometryEffect(id: "sidebarActivePill", in: sidebarHighlightNamespace)
                                    .shadow(color: Theme.primarySlate.opacity(0.15), radius: 8, x: 0, y: 4)
                            }
                        }
                    )
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
            
            // Avatar profile card at bottom of sidebar
            HStack(spacing: 10) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(Theme.primarySlate)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Yunus Bey")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Theme.textDark)
                    Text("Executive CEO")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Theme.textMuted)
                }
            }
            .padding(12)
            .background(Theme.secondaryBackground.opacity(0.6))
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Theme.background.ignoresSafeArea())
    }
}

// MARK: - Main Dashboard Pane
struct DashboardMainView: View {
    @Binding var selectedProject: Project?
    let data = MockData.shared
    
    var body: some View {
        VStack(spacing: 20) {
            KPIGridView(cards: data.kpiCards)
            
            DualAxisChart(data: data.monthlyData)
            
            AdaptiveStackView {
                SiteStatusDonutChart()
                SalesFunnelChartView(stages: data.funnelStages)
            }
            
            CriticalProjectsListView(projects: data.criticalProjects) { project in
                selectedProject = project
            }
        }
    }
}

// MARK: - Adaptive Grid for KPIs
struct KPIGridView: View {
    let cards: [KPICardData]
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        let columns = sizeClass == .compact ?
            [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)] :
            [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16),
             GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
        
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(cards) { card in
                KPICardView(data: card)
            }
        }
    }
}

// MARK: - Adaptive Stack View (Adapts layout depending on screen class)
struct AdaptiveStackView<Content: View>: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Group {
            if sizeClass == .compact {
                VStack(spacing: 20) {
                    content
                }
            } else {
                HStack(alignment: .top, spacing: 20) {
                    content
                }
            }
        }
    }
}

// MARK: - Project Detail Sheet/Modal View
struct ProjectDetailView: View {
    let project: Project
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 20) {
                    // Header card
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(project.location)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Theme.accentCopper)
                                .textCase(.uppercase)
                            Spacer()
                            Text(project.budgetStatus.rawValue)
                                .font(.system(size: 11, weight: .bold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(project.budgetStatus == .overBudget ? Theme.stateRed.opacity(0.1) : Theme.stateGreen.opacity(0.1))
                                .foregroundColor(project.budgetStatus == .overBudget ? Theme.stateRed : Theme.stateGreen)
                                .cornerRadius(12)
                        }
                        
                        Text(project.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Theme.textDark)
                        
                        Text("Deadline: \(project.deadline)")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textMuted)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.secondaryBackground)
                    .cornerRadius(16)
                    
                    // Detailed metrics
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Total Budget")
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textMuted)
                            Text("₺\(String(format: "%.1fM", project.budget / 1000000.0))")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.textDark)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.border, lineWidth: 1))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Site Manager")
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textMuted)
                            Text(project.siteManager)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Theme.textDark)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.border, lineWidth: 1))
                    }
                    
                    // Progress meter
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Construction Completion")
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                            Text("\(Int(project.progress * 100))%")
                                .font(.system(size: 14, weight: .bold))
                        }
                        
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Theme.border)
                                .frame(height: 10)
                            Capsule()
                                .fill(Theme.accentCopper)
                                .frame(width: 320 * CGFloat(project.progress), height: 10)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Executive Project Brief")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.textDark)
                        Text(project.description)
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textMuted)
                            .lineSpacing(4)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    // Action controls
                    HStack(spacing: 12) {
                        Button {
                            // Dial manager simulator
                        } label: {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text("Call Manager")
                            }
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.primarySlate)
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            // Email manager simulator
                        } label: {
                            HStack {
                                Image(systemName: "envelope.fill")
                                Text("Email Brief")
                            }
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.textDark)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.primarySlate, lineWidth: 1.5))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
            .background(Theme.background)
            #if os(iOS)
            .navigationTitle("Project Overview")
            .navigationBarTitleDisplayMode(.inline)
            #else
            .navigationTitle("Project Overview")
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Theme.accentCopper)
                    .font(.system(size: 14, weight: .bold))
                }
            }
        }
    }
}

// MARK: - Projects Main List Pane (for iPad/Mac detail)
struct ProjectsMainPane: View {
    @Binding var selectedProject: Project?
    let data = MockData.shared
    
    var body: some View {
        VStack(spacing: 20) {
            ProjectsListView(selectedProject: $selectedProject)
        }
    }
}

// MARK: - Modular Projects List
struct ProjectsListView: View {
    @Binding var selectedProject: Project?
    let data = MockData.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Corporate Real Estate & Civil Portfolios")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Theme.textDark)
                .padding(.horizontal, 4)
            
            ForEach(data.criticalProjects) { project in
                Button {
                    selectedProject = project
                } label: {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(project.name)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Theme.textDark)
                            
                            HStack(spacing: 12) {
                                Text(project.location)
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.textMuted)
                                Text("•")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.textMuted)
                                Text("Budget: ₺\(String(format: "%.1fM", project.budget / 1000000.0))")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.textMuted)
                            }
                        }
                        
                        Spacer()
                        
                        // Status widget
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("\(Int(project.progress * 100))% Done")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.accentCopper)
                            
                            Text(project.budgetStatus.rawValue)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(project.budgetStatus == .overBudget ? Theme.stateRed : Theme.stateGreen)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.border, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Clients List View
struct ClientsListView: View {
    let data = MockData.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Client & Investor Accounts")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Theme.textDark)
                .padding(.horizontal, 4)
            
            ForEach(data.clients) { client in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(client.name)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Theme.textDark)
                            Text("Contact: \(client.contactPerson)")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textMuted)
                        }
                        
                        Spacer()
                        
                        Text(client.status)
                            .font(.system(size: 11, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(client.status == "Active" || client.status == "Contract Signed" ? Theme.stateGreen.opacity(0.12) : Theme.accentCopper.opacity(0.12))
                            .foregroundColor(client.status == "Active" || client.status == "Contract Signed" ? Theme.stateGreen : Theme.accentCopper)
                            .cornerRadius(12)
                    }
                    
                    Divider()
                        .background(Theme.border)
                    
                    HStack {
                        Text(client.email)
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textMuted)
                        
                        Spacer()
                        
                        Text("Portfolio Revenue: ₺\(String(format: "%.1fM", client.totalRevenue / 1000000.0))")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textDark)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.border, lineWidth: 1))
            }
        }
    }
}

// MARK: - Sales Pipeline View
struct SalesPipelineView: View {
    let data = MockData.shared
    
    var body: some View {
        VStack(spacing: 20) {
            SalesFunnelChartView(stages: data.funnelStages)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Negotiation & Bidding Pipelines")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.textDark)
                
                ForEach(data.clients.filter { $0.status == "Negotiation" || $0.status == "Lead" }) { client in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(client.name)
                                .font(.system(size: 13, weight: .bold))
                            Text("Awaiting signature proposal")
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textMuted)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("₺\(String(format: "%.1fM", client.totalRevenue / 1000000.0))")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Theme.accentCopper)
                            Text(client.status)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(Theme.textMuted)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.border, lineWidth: 1))
                }
            }
        }
    }
}

// MARK: - Reports Main View
struct ReportsMainView: View {
    let data = MockData.shared
    @State private var showingExportAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            // General Stats report card
            VStack(alignment: .leading, spacing: 16) {
                Text("Q2 Construction Portfolio Performance")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.textDark)
                
                VStack(spacing: 12) {
                    ReportRow(title: "Sales Target Achievement", value: "98.2%", color: Theme.stateGreen)
                    ReportRow(title: "Safety Standard Compliance", value: "100%", color: Theme.stateGreen)
                    ReportRow(title: "Material Budget Variance", value: "+2.4% Over", color: Theme.stateRed)
                    ReportRow(title: "Resource Utilization Index", value: "91.8%", color: Theme.accentCopper)
                }
                
                Button {
                    showingExportAlert = true
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: "doc.badge.arrow.up.fill")
                        Text("Export Executive PDF Report")
                        Spacer()
                    }
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Theme.primarySlate)
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
            }
            .glassCardStyle()
            
            // Chart repetition for visual reference
            DualAxisChart(data: data.monthlyData)
        }
        .alert("Report Export", isPresented: $showingExportAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Executive summary PDF compiled successfully. Sent to yunus.bey@paletcrm.com.")
        }
    }
}

struct ReportRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(Theme.textMuted)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(color)
        }
        .padding(.vertical, 4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
