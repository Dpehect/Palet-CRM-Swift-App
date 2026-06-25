//
//  WatchComplicationsView.swift
//  Palet Crm
//
//  Created by Antigravity on 25.06.2026.
//

import SwiftUI

struct WatchComplicationsView: View {
    @State private var activeComplication = 0 // 0: Modular, 1: Projects Ring, 2: Sales Ring, 3: Site status
    @State private var watchAnimate = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Simulator title
            VStack(spacing: 4) {
                Text("Apple Watch Complications")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Theme.textDark)
                Text("Glanceable dashboard widgets")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textMuted)
            }
            
            // Watch Chassis Simulation
            ZStack {
                // Outer strap
                RoundedRectangle(cornerRadius: 30)
                    .fill(Theme.primarySlate.opacity(0.85))
                    .frame(width: 140, height: 380)
                    .shadow(color: Color.black.opacity(0.25), radius: 15, x: 0, y: 10)
                
                // Watch Case
                RoundedRectangle(cornerRadius: 38)
                    .fill(Color(red: 45/255, green: 45/255, blue: 48/255)) // Space Gray Aluminium
                    .frame(width: 200, height: 240)
                    .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 38)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                    )
                
                // Digital Crown
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(red: 30/255, green: 30/255, blue: 32/255))
                    .frame(width: 12, height: 50)
                    .offset(x: 102, y: -40)
                
                // Side Button
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(red: 35/255, green: 35/255, blue: 37/255))
                    .frame(width: 6, height: 60)
                    .offset(x: 101, y: 35)
                
                // Watch Screen Screen
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.black)
                    .frame(width: 182, height: 222)
                    .overlay(
                        VStack(spacing: 8) {
                            // Top Bar (Time and Notifications)
                            HStack {
                                Text("10:09")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                Spacer()
                                Circle()
                                    .fill(Theme.stateRed)
                                    .frame(width: 6, height: 6)
                                Spacer()
                                Image(systemName: "location.fill")
                                    .font(.system(size: 9))
                                    .foregroundColor(Theme.accentCopper)
                            }
                            .padding(.horizontal, 14)
                            .padding(.top, 12)
                            
                            // Watch Complications Area
                            VStack(spacing: 6) {
                                // Upper Row: Two circular dials
                                HStack(spacing: 16) {
                                    // Complication 1: Active Projects ring
                                    WatchCircularRing(
                                        title: "PRJ",
                                        value: "12",
                                        color: Theme.accentCopper,
                                        progress: 0.85,
                                        isActive: activeComplication == 1,
                                        action: { activeComplication = 1 }
                                    )
                                    
                                    // Complication 2: Site Status ring
                                    WatchCircularRing(
                                        title: "SIT",
                                        value: "80%",
                                        color: Theme.stateGreen,
                                        progress: 0.8,
                                        isActive: activeComplication == 2,
                                        action: { activeComplication = 2 }
                                    )
                                }
                                
                                // Center Complication: Infograph Modular text
                                Button {
                                    activeComplication = 0
                                } label: {
                                    VStack(alignment: .leading, spacing: 3) {
                                        HStack {
                                            Image(systemName: "turkishlirasign.circle.fill")
                                                .foregroundColor(Theme.accentCopper)
                                                .font(.system(size: 11))
                                            Text("CRM SALES")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(Theme.accentCopper)
                                            Spacer()
                                        }
                                        
                                        Text("₺4.5M Total Sales")
                                            .font(.system(size: 12, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                        
                                        Text("+12.5% this month")
                                            .font(.system(size: 10))
                                            .foregroundColor(Theme.stateGreen)
                                    }
                                    .padding(8)
                                    .frame(width: 156, height: 62)
                                    .background(Color.white.opacity(activeComplication == 0 ? 0.15 : 0.08))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(activeComplication == 0 ? Theme.accentCopper.opacity(0.6) : Color.clear, lineWidth: 1.5)
                                    )
                                }
                                .buttonStyle(.plain)
                                
                                // Bottom Complication: Leads Info
                                Button {
                                    activeComplication = 3
                                } label: {
                                    HStack {
                                        Image(systemName: "person.crop.circle.badge.plus")
                                            .font(.system(size: 11))
                                            .foregroundColor(.cyan)
                                        Text("85 Pending Leads")
                                            .font(.system(size: 10, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 10)
                                    .background(Color.white.opacity(activeComplication == 3 ? 0.15 : 0.08))
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(activeComplication == 3 ? Color.cyan.opacity(0.6) : Color.clear, lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                            
                            Spacer()
                        }
                    )
            }
            .scaleEffect(watchAnimate ? 1.0 : 0.9)
            .opacity(watchAnimate ? 1.0 : 0.0)
            
            // Detail box showing information based on selected complication
            VStack {
                switch activeComplication {
                case 0:
                    WatchComplicationDetailView(
                        title: "Sales Complication",
                        desc: "Displays real-time sales achievements (₺4.5M) and percentage growth against target for executive tracking.",
                        metric: "₺4.5M (+12.5%)"
                    )
                case 1:
                    WatchComplicationDetailView(
                        title: "Projects Complication",
                        desc: "Ring progress indicating Active Projects vs Pipeline targets. Fully interactive on tap.",
                        metric: "12 Projects (+2)"
                    )
                case 2:
                    WatchComplicationDetailView(
                        title: "Site Status Complication",
                        desc: "Monitors overall health index of all field work. 8 on track out of 10 total active sites.",
                        metric: "80% Safety/On-Track"
                    )
                default:
                    WatchComplicationDetailView(
                        title: "Leads Complication",
                        desc: "Corner text and badge highlighting pending client bids that require quick response.",
                        metric: "85 Pending Leads"
                    )
                }
            }
            .frame(height: 100)
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            withAnimation(Theme.slowSpring) {
                watchAnimate = true
            }
        }
    }
}

// MARK: - Watch Circular Complication Ring
struct WatchCircularRing: View {
    let title: String
    let value: String
    let color: Color
    let progress: Double
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Background Track
                Circle()
                    .stroke(Color.white.opacity(0.12), lineWidth: 3.5)
                    .frame(width: 48, height: 48)
                
                // Active Progress
                Circle()
                    .trim(from: 0.0, to: CGFloat(progress))
                    .stroke(color, style: StrokeStyle(lineWidth: 3.5, lineCap: .round))
                    .frame(width: 48, height: 48)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 0) {
                    Text(title)
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.gray)
                    Text(value)
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 52, height: 52)
            .background(isActive ? Color.white.opacity(0.1) : Color.clear)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(isActive ? color.opacity(0.8) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Watch Complication Detail View
struct WatchComplicationDetailView: View {
    let title: String
    let desc: String
    let metric: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Theme.accentCopper)
                .tracking(1.5)
            
            Text(metric)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textDark)
            
            Text(desc)
                .font(.system(size: 12))
                .foregroundColor(Theme.textMuted)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
}
