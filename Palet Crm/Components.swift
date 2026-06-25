//
//  Components.swift
//  Palet Crm
//
//  Created by Antigravity on 25.06.2026.
//

import SwiftUI

// MARK: - KPI Card View (Overhauled with Glassmorphism and press/lift interactions)
struct KPICardView: View {
    let data: KPICardData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                // Glow-backed Icon
                ZStack {
                    Circle()
                        .fill(data.title == "Total Sales" ? Theme.accentCopper.opacity(0.12) : Theme.primarySlate.opacity(0.08))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: data.iconName)
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundStyle(data.title == "Total Sales" ? Theme.accentCopper : Theme.primarySlate)
                }
                .shadow(color: data.title == "Total Sales" ? Theme.accentCopper.opacity(0.15) : Color.clear, radius: 8, x: 0, y: 4)
                
                Spacer()
                
                // Trend Badge
                if let isPositive = data.isPositive {
                    HStack(spacing: 4) {
                        Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 11, weight: .bold))
                        Text(data.trend)
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(isPositive ? Theme.stateGreen.opacity(0.12) : Theme.stateRed.opacity(0.12))
                    .foregroundColor(isPositive ? Theme.stateGreen : Theme.stateRed)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isPositive ? Theme.stateGreen.opacity(0.3) : Theme.stateRed.opacity(0.3), lineWidth: 0.8)
                    )
                } else {
                    Text(data.trend)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Theme.textMuted.opacity(0.12))
                        .foregroundColor(Theme.textMuted)
                        .cornerRadius(20)
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(data.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.textMuted)
                
                HStack(alignment: .bottom, spacing: 8) {
                    Text(data.value)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textDark)
                    
                    if data.title == "Site Status" {
                        MiniDonutView()
                            .frame(width: 26, height: 26)
                            .padding(.bottom, 4)
                    }
                }
            }
            
            Text(data.detail)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Theme.textMuted)
        }
        .padding(18)
        .glassCardStyle()
        .frame(height: 165)
        .luxury3DTilt() // Responsive Press/Lift Scale effects (Optimized for Scroll)
    }
}

// MARK: - Mini Donut Chart for KPI Card
struct MiniDonutView: View {
    @State private var animateIn = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Theme.stateRed.opacity(0.2), lineWidth: 4.5)
            Circle()
                .trim(from: 0.0, to: animateIn ? 0.8 : 0.0)
                .stroke(Theme.stateGreen, style: StrokeStyle(lineWidth: 4.5, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0).delay(0.2)) {
                animateIn = true
            }
        }
    }
}

// MARK: - Site Status Donut Chart View (Overhauled with Exploding Segments)
struct SiteStatusDonutChart: View {
    @State private var drawFraction: Double = 0.0
    @State private var selectedSector: Int? = nil // nil: none, 0: On Track, 1: Delayed
    
    var body: some View {
        VStack(spacing: 18) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Site Construction Status")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textDark)
                    Text("Tap segments to inspect")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                }
                Spacer()
                Image(systemName: "circle.dashed.inset.filled")
                    .foregroundColor(Theme.accentCopper)
            }
            
            HStack(spacing: 24) {
                // Interactive Exploding Donut Graphic
                ZStack {
                    // 1. Delayed Segment (20% -> 0.2)
                    let delayedAngle = 234.0 * .pi / 180.0
                    let delayedOffsetX = selectedSector == 1 ? cos(delayedAngle) * 12 : 0.0
                    let delayedOffsetY = selectedSector == 1 ? sin(delayedAngle) * 12 : 0.0
                    
                    Circle()
                        .stroke(Theme.stateRed.opacity(0.18), lineWidth: 22)
                        .frame(width: 120, height: 120)
                        .offset(x: delayedOffsetX, y: delayedOffsetY)
                        .animation(Theme.standardSpring, value: selectedSector)
                    
                    // 2. On Track Segment (80% -> 0.8)
                    let onTrackAngle = 54.0 * .pi / 180.0
                    let onTrackOffsetX = selectedSector == 0 ? cos(onTrackAngle) * 12 : 0.0
                    let onTrackOffsetY = selectedSector == 0 ? sin(onTrackAngle) * 12 : 0.0
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(drawFraction * 0.8))
                        .stroke(
                            LinearGradient(colors: [Theme.stateGreen, Theme.stateGreen.opacity(0.8)], startPoint: .top, endPoint: .bottom),
                            style: StrokeStyle(lineWidth: 22, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .offset(x: onTrackOffsetX, y: onTrackOffsetY)
                        .shadow(color: Theme.stateGreen.opacity(selectedSector == 0 ? 0.35 : 0.05), radius: 8, x: 0, y: 4)
                        .animation(Theme.standardSpring, value: selectedSector)
                        .onTapGesture {
                            withAnimation(Theme.quickSpring) {
                                if selectedSector == 0 { selectedSector = nil }
                                else { selectedSector = 0 }
                            }
                        }
                    
                    // 3. Delayed Overlay segment click trigger
                    Circle()
                        .trim(from: CGFloat(drawFraction * 0.8), to: CGFloat(drawFraction))
                        .stroke(
                            LinearGradient(colors: [Theme.stateRed, Theme.stateRed.opacity(0.8)], startPoint: .top, endPoint: .bottom),
                            style: StrokeStyle(lineWidth: 22, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .offset(x: delayedOffsetX, y: delayedOffsetY)
                        .shadow(color: Theme.stateRed.opacity(selectedSector == 1 ? 0.35 : 0.05), radius: 8, x: 0, y: 4)
                        .animation(Theme.standardSpring, value: selectedSector)
                        .onTapGesture {
                            withAnimation(Theme.quickSpring) {
                                if selectedSector == 1 { selectedSector = nil }
                                else { selectedSector = 1 }
                            }
                        }
                    
                    // Central informative panel
                    VStack(spacing: 1) {
                        Text(selectedSector == nil ? "80%" : (selectedSector == 0 ? "8" : "2"))
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textDark)
                            .transition(.scale.combined(with: .opacity))
                            .id(selectedSector)
                        
                        Text(selectedSector == nil ? "On Track" : (selectedSector == 0 ? "On Track" : "Delayed"))
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Theme.textMuted)
                            .id(selectedSector)
                    }
                }
                .frame(width: 140, height: 140)
                
                // Legend
                VStack(alignment: .leading, spacing: 14) {
                    Button {
                        withAnimation(Theme.quickSpring) {
                            selectedSector = selectedSector == 0 ? nil : 0
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Theme.stateGreen)
                                .frame(width: 11, height: 11)
                                .scaleEffect(selectedSector == 0 ? 1.3 : 1.0)
                            
                            VStack(alignment: .leading, spacing: 1) {
                                Text("8 On Track")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(selectedSector == 0 ? Theme.stateGreen : Theme.textDark)
                                Text("Inspect details")
                                    .font(.system(size: 10))
                                    .foregroundColor(Theme.textMuted)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        withAnimation(Theme.quickSpring) {
                            selectedSector = selectedSector == 1 ? nil : 1
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Theme.stateRed)
                                .frame(width: 11, height: 11)
                                .scaleEffect(selectedSector == 1 ? 1.3 : 1.0)
                            
                            VStack(alignment: .leading, spacing: 1) {
                                Text("2 Delayed")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(selectedSector == 1 ? Theme.stateRed : Theme.textDark)
                                Text("Inspect details")
                                    .font(.system(size: 10))
                                    .foregroundColor(Theme.textMuted)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 8)
        }
        .padding(18)
        .glassCardStyle()
        .luxury3DTilt()
        .onAppear {
            withAnimation(.easeOut(duration: 1.1)) {
                drawFraction = 1.0
            }
        }
    }
}

// MARK: - Dual Axis Line Chart (Tappable Navigation - No Drag Conflicts)
struct DualAxisChart: View {
    let data: [SalesProgressDataPoint]
    @State private var animateChart = false
    @State private var selectedIndex = 11 // Default to latest month (Dec)
    @State private var showTooltip = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Monthly Sales & Project Progress")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textDark)
                    Text("Tap data nodes or months to inspect metrics")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textMuted)
                }
                
                Spacer()
                
                // Indicators
                HStack(spacing: 18) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Theme.accentCopper)
                            .frame(width: 9, height: 9)
                        Text("Sales (₺)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Theme.textMuted)
                    }
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Theme.stateGreen)
                            .frame(width: 9, height: 9)
                        Text("Progress (%)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Theme.textMuted)
                    }
                }
            }
            
            // Neon Glow Trail Scrubber Canvas
            GeometryReader { geo in
                let width = geo.size.width - 70
                let height = geo.size.height - 35
                let paddingLeft: CGFloat = 35
                
                let maxSales = 5.0
                let maxProgress = 100.0
                
                // Compute coordinates
                let salesPoints = data.enumerated().map { (index, point) -> CGPoint in
                    let x = paddingLeft + (CGFloat(index) * (width / CGFloat(data.count - 1)))
                    let y = height - (CGFloat(point.salesAmount / maxSales) * height)
                    return CGPoint(x: x, y: y)
                }
                
                let progressPoints = data.enumerated().map { (index, point) -> CGPoint in
                    let x = paddingLeft + (CGFloat(index) * (width / CGFloat(data.count - 1)))
                    let y = height - (CGFloat(point.progressPercent / maxProgress) * height)
                    return CGPoint(x: x, y: y)
                }
                
                ZStack {
                    // 1. Grid lines
                    ForEach(0...4, id: \.self) { i in
                        let yPos = CGFloat(i) * (height / 4)
                        Path { path in
                            path.move(to: CGPoint(x: paddingLeft, y: yPos))
                            path.addLine(to: CGPoint(x: paddingLeft + width, y: yPos))
                        }
                        .stroke(Theme.border.opacity(0.65), lineWidth: 0.8)
                        
                        // Left Axis labels
                        let salesValue = maxSales - (Double(i) * (maxSales / 4.0))
                        Text(String(format: "₺%.1fM", salesValue))
                            .font(.system(size: 9, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textMuted)
                            .position(x: 16, y: yPos)
                        
                        // Right Axis labels
                        let progressValue = maxProgress - (Double(i) * (maxProgress / 4.0))
                        Text(String(format: "%.0f%%", progressValue))
                            .font(.system(size: 9, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textMuted)
                            .position(x: paddingLeft + width + 18, y: yPos)
                    }
                    
                    // 2. Copper Neon Glow Trail (Blurred path)
                    Path { path in
                        guard !salesPoints.isEmpty else { return }
                        path.move(to: salesPoints[0])
                        for i in 1..<salesPoints.count {
                            path.addLine(to: salesPoints[i])
                        }
                    }
                    .trim(from: 0, to: animateChart ? 1.0 : 0.0)
                    .stroke(Theme.accentCopper.opacity(0.35), lineWidth: 8)
                    .blur(radius: 6)
                    
                    Path { path in
                        guard !salesPoints.isEmpty else { return }
                        path.move(to: salesPoints[0])
                        for i in 1..<salesPoints.count {
                            path.addLine(to: salesPoints[i])
                        }
                    }
                    .trim(from: 0, to: animateChart ? 1.0 : 0.0)
                    .stroke(Theme.accentCopper, style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round))
                    
                    // Area Gradient under Sales
                    Path { path in
                        guard !salesPoints.isEmpty else { return }
                        path.move(to: CGPoint(x: salesPoints[0].x, y: height))
                        for pt in salesPoints {
                            path.addLine(to: pt)
                        }
                        path.addLine(to: CGPoint(x: salesPoints.last!.x, y: height))
                        path.closeSubpath()
                    }
                    .fill(LinearGradient(colors: [Theme.accentCopper.opacity(0.16), Theme.accentCopper.opacity(0.0)], startPoint: .top, endPoint: .bottom))
                    .opacity(animateChart ? 1.0 : 0.0)
                    
                    // 3. Green Neon Glow Trail
                    Path { path in
                        guard !progressPoints.isEmpty else { return }
                        path.move(to: progressPoints[0])
                        for i in 1..<progressPoints.count {
                            path.addLine(to: progressPoints[i])
                        }
                    }
                    .trim(from: 0, to: animateChart ? 1.0 : 0.0)
                    .stroke(Theme.stateGreen.opacity(0.3), lineWidth: 8)
                    .blur(radius: 5)
                    
                    Path { path in
                        guard !progressPoints.isEmpty else { return }
                        path.move(to: progressPoints[0])
                        for i in 1..<progressPoints.count {
                            path.addLine(to: progressPoints[i])
                        }
                    }
                    .trim(from: 0, to: animateChart ? 1.0 : 0.0)
                    .stroke(Theme.stateGreen, style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round))
                    
                    // Area Gradient under Progress
                    Path { path in
                        guard !progressPoints.isEmpty else { return }
                        path.move(to: CGPoint(x: progressPoints[0].x, y: height))
                        for pt in progressPoints {
                            path.addLine(to: pt)
                        }
                        path.addLine(to: CGPoint(x: progressPoints.last!.x, y: height))
                        path.closeSubpath()
                    }
                    .fill(LinearGradient(colors: [Theme.stateGreen.opacity(0.12), Theme.stateGreen.opacity(0.0)], startPoint: .top, endPoint: .bottom))
                    .opacity(animateChart ? 1.0 : 0.0)
                    
                    // Static Data Points dots
                    if animateChart {
                        ForEach(0..<data.count, id: \.self) { idx in
                            Circle()
                                .fill(Theme.accentCopper)
                                .frame(width: selectedIndex == idx && showTooltip ? 10 : 5)
                                .position(salesPoints[idx])
                                .shadow(color: Theme.accentCopper.opacity(0.5), radius: 3)
                            
                            Circle()
                                .fill(Theme.stateGreen)
                                .frame(width: selectedIndex == idx && showTooltip ? 10 : 5)
                                .position(progressPoints[idx])
                                .shadow(color: Theme.stateGreen.opacity(0.5), radius: 3)
                        }
                    }
                    
                    // 4. Vertical Selector Guide & Tooltip (Tappable implementation)
                    if showTooltip && selectedIndex < data.count && animateChart {
                        let currentX = salesPoints[selectedIndex].x
                        
                        // Vertical guideline
                        Path { p in
                            p.move(to: CGPoint(x: currentX, y: 0))
                            p.addLine(to: CGPoint(x: currentX, y: height))
                        }
                        .stroke(Theme.primarySlate.opacity(0.25), style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [4, 4]))
                        
                        // Interactive Tooltip popover
                        VStack(alignment: .leading, spacing: 4) {
                            Text(data[selectedIndex].month.uppercased())
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(Theme.textMuted)
                            Text("Sales: ₺\(String(format: "%.2fM", data[selectedIndex].salesAmount))")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.accentCopper)
                            Text("Progress: \(Int(data[selectedIndex].progressPercent))%")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.stateGreen)
                        }
                        .padding(9)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Theme.accentCopper.opacity(0.3), lineWidth: 1)
                        )
                        .position(x: currentX, y: max(42, salesPoints[selectedIndex].y - 50))
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    // 5. Large Invisible Touch Targets (Overlayed on top of points to block NO scrolling)
                    ForEach(0..<data.count, id: \.self) { idx in
                        Button {
                            withAnimation(Theme.quickSpring) {
                                selectedIndex = idx
                                showTooltip = true
                            }
                        } label: {
                            Circle()
                                .fill(Color.black.opacity(0.0001)) // Invisible but interactable
                                .frame(width: 32, height: 32)
                        }
                        .buttonStyle(.plain)
                        .position(salesPoints[idx])
                    }
                    
                    // 6. X-Axis month labels as filter buttons
                    ForEach(0..<data.count, id: \.self) { idx in
                        let xPos = paddingLeft + (CGFloat(idx) * (width / CGFloat(data.count - 1)))
                        Button {
                            withAnimation(Theme.quickSpring) {
                                selectedIndex = idx
                                showTooltip = true
                            }
                        } label: {
                            Text(data[idx].month)
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundColor(selectedIndex == idx && showTooltip ? Theme.accentCopper : Theme.textMuted)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 6)
                                .background(selectedIndex == idx && showTooltip ? Theme.accentCopper.opacity(0.1) : Color.clear)
                                .cornerRadius(6)
                        }
                        .buttonStyle(.plain)
                        .position(x: xPos, y: height + 18)
                    }
                }
            }
            .frame(height: 235)
            .padding(.top, 8)
        }
        .padding(18)
        .glassCardStyle()
        .luxury3DTilt()
        .onAppear {
            withAnimation(.easeInOut(duration: 1.1)) {
                animateChart = true
            }
        }
    }
}

// MARK: - Sales Funnel View (Upgraded with Glass Chevrons Flow)
struct SalesFunnelChartView: View {
    let stages: [FunnelStage]
    @State private var animateStages = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("Sales Conversion Pipeline")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Theme.textDark)
                Spacer()
                Image(systemName: "chart.bar.doc.horizontal.fill")
                    .foregroundColor(Theme.accentCopper)
            }
            
            // Glass Chevron Flow Layout
            VStack(spacing: 8) {
                ForEach(stages.indices, id: \.self) { idx in
                    let stage = stages[idx]
                    
                    HStack(spacing: 12) {
                        GeometryReader { barGeo in
                            let maxWidth = barGeo.size.width
                            let narrowingFactor = 1.0 - (Double(idx) * 0.16)
                            let currentWidth = animateStages ? (maxWidth * CGFloat(narrowingFactor)) : 0.0
                            
                            HStack(spacing: 0) {
                                HStack {
                                    // Stage icon status
                                    Circle()
                                        .fill(.white.opacity(0.3))
                                        .frame(width: 22, height: 22)
                                        .overlay(
                                            Text("\(idx + 1)")
                                                .font(.system(size: 11, weight: .bold))
                                                .foregroundColor(.white)
                                        )
                                    
                                    Text(stage.name)
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text("\(stage.count) leads")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                .padding(.horizontal, 14)
                                .frame(width: max(130, currentWidth), height: 44, alignment: .leading)
                                .background(
                                    LinearGradient(
                                        colors: [
                                            idx == 0 ? Theme.primarySlate : (idx == 1 ? Theme.accentCopper : (idx == 2 ? Theme.secondarySlate : Theme.stateGreen)),
                                            idx == 0 ? Theme.primarySlate.opacity(0.8) : (idx == 1 ? Theme.accentCopper.opacity(0.8) : (idx == 2 ? Theme.secondarySlate.opacity(0.8) : Theme.stateGreen.opacity(0.8)))
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(10)
                                .shadow(
                                    color: (idx == 1 ? Theme.accentCopper : Theme.primarySlate).opacity(0.12),
                                    radius: 6, x: 0, y: 3
                                )
                                
                                Spacer()
                            }
                        }
                        .frame(height: 44)
                        
                        // Conversion Badge
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(String(format: "%.1f%%", stage.rate))
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(idx == 1 ? Theme.accentCopper : Theme.textDark)
                            Text(idx == 0 ? "Initial" : "Conv. Rate")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(Theme.textMuted)
                        }
                        .frame(width: 78, alignment: .trailing)
                    }
                    
                    if idx < stages.count - 1 {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Theme.textMuted.opacity(0.4))
                            .padding(.vertical, 1)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .padding(18)
        .glassCardStyle()
        .luxury3DTilt()
        .onAppear {
            withAnimation(Theme.slowSpring.delay(0.15)) {
                animateStages = true
            }
        }
    }
}

// MARK: - Critical Projects List View (Luxury Glass Rows)
struct CriticalProjectsListView: View {
    let projects: [Project]
    var onSelect: (Project) -> Void
    @State private var hoveredIdx: Int? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Critical Project Status")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textDark)
                    Text("Tap rows to review full briefing reports")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                }
                Spacer()
                Image(systemName: "briefcase.fill")
                    .foregroundColor(Theme.accentCopper)
            }
            
            VStack(spacing: 8) {
                ForEach(projects.indices, id: \.self) { idx in
                    let project = projects[idx]
                    
                    Button {
                        onSelect(project)
                    } label: {
                        HStack(spacing: 14) {
                            // Site Manager Monogram
                            ZStack {
                                Circle()
                                    .fill(Theme.primarySlate.opacity(0.08))
                                    .frame(width: 38, height: 38)
                                Text(project.managerAvatar)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Theme.primarySlate)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Text(project.name)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(Theme.textDark)
                                        .lineLimit(1)
                                    
                                    Circle()
                                        .fill(project.budgetStatus == .overBudget ? Theme.stateRed : Theme.stateGreen)
                                        .frame(width: 8, height: 8)
                                        .shadow(color: (project.budgetStatus == .overBudget ? Theme.stateRed : Theme.stateGreen).opacity(0.4), radius: 3)
                                }
                                
                                HStack(spacing: 8) {
                                    Text(project.siteManager)
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(Theme.textMuted)
                                    Text("•")
                                        .font(.system(size: 11))
                                        .foregroundColor(Theme.textMuted)
                                    Text(project.deadline)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(Theme.textMuted)
                                }
                            }
                            
                            Spacer()
                            
                            // Animated mini-progress bar
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("\(Int(project.progress * 100))%")
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.accentCopper)
                                
                                GeometryReader { barGeo in
                                    let barWidth = barGeo.size.width
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(Theme.border.opacity(0.8))
                                            .frame(height: 5.5)
                                        Capsule()
                                            .fill(project.progress > 0.8 ? Theme.stateGreen : Theme.accentCopper)
                                            .frame(width: barWidth * CGFloat(project.progress), height: 5.5)
                                            .shadow(color: (project.progress > 0.8 ? Theme.stateGreen : Theme.accentCopper).opacity(0.35), radius: 3)
                                    }
                                }
                                .frame(width: 70, height: 5.5)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(hoveredIdx == idx ? Theme.secondaryBackground.opacity(0.5) : Color.clear)
                        )
                        .scaleEffect(hoveredIdx == idx ? 1.015 : 1.0)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    if idx < projects.count - 1 {
                        Divider()
                            .background(Theme.border.opacity(0.7))
                    }
                }
            }
        }
        .padding(18)
        .glassCardStyle()
        .luxury3DTilt()
    }
}
