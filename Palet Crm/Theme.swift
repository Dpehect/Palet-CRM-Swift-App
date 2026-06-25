//
//  Theme.swift
//  Palet Crm
//
//  Created by Antigravity on 25.06.2026.
//

import SwiftUI

struct Theme {
    // Premium Color Palette
    static let primarySlate = Color(red: 44/255, green: 62/255, blue: 80/255)       // #2C3E50 (Deep Slate Blue)
    static let secondarySlate = Color(red: 52/255, green: 73/255, blue: 94/255)     // #34495E
    static let accentCopper = Color(red: 230/255, green: 126/255, blue: 34/255)     // #E67E22 (Brushed Copper)
    static let accentCopperLight = Color(red: 243/255, green: 156/255, blue: 18/255) // #F39C12 (Warm Gold/Copper)
    
    // Status Colors
    static let stateGreen = Color(red: 46/255, green: 204/255, blue: 113/255)       // #2ECC71 (Soft Green)
    static let stateRed = Color(red: 231/255, green: 76/255, blue: 60/255)          // #E74C3C (Soft Red)
    static let stateOrange = Color(red: 241/255, green: 196/255, blue: 15/255)      // #F1C40F (Amber/Yellow)
    
    // Interface Colors
    static let background = Color(red: 245/255, green: 247/255, blue: 250/255)      // Modern soft background
    static let secondaryBackground = Color(red: 238/255, green: 242/255, blue: 245/255)
    static let cardBackground = Color.white
    static let border = Color(red: 226/255, green: 232/255, blue: 240/255)
    
    // Text Colors
    static let textDark = Color(red: 20/255, green: 30/255, blue: 45/255)
    static let textMuted = Color(red: 120/255, green: 130/255, blue: 145/255)
    
    // Gradients
    static let copperGradient = LinearGradient(
        colors: [accentCopper, accentCopperLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let slateGradient = LinearGradient(
        colors: [primarySlate, secondarySlate],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let successGradient = LinearGradient(
        colors: [stateGreen, stateGreen.opacity(0.85)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let warningGradient = LinearGradient(
        colors: [stateRed, stateRed.opacity(0.85)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Shadows
    static let premiumShadow = Shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 6)
    static let intenseShadow = Shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 10)
    static let glassShadow = Shadow(color: primarySlate.opacity(0.04), radius: 12, x: 0, y: 8)
    static let copperGlow = Shadow(color: accentCopper.opacity(0.25), radius: 12, x: 0, y: 6)
    static let greenGlow = Shadow(color: stateGreen.opacity(0.2), radius: 10, x: 0, y: 5)
    
    // Spring Animations
    static let standardSpring = Animation.spring(response: 0.4, dampingFraction: 0.76, blendDuration: 0)
    static let quickSpring = Animation.spring(response: 0.22, dampingFraction: 0.65, blendDuration: 0)
    static let slowSpring = Animation.spring(response: 0.65, dampingFraction: 0.82, blendDuration: 0)
    
    // Awwwards-level morphing spring
    static let morphingSpring = Animation.interpolatingSpring(stiffness: 140, damping: 14.5)
    static let fluidSpring = Animation.spring(response: 0.36, dampingFraction: 0.71, blendDuration: 0)
    
    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
}

// MARK: - Awwwards Glassmorphism Modifier
struct GlassmorphicCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.65))
                    .background(
                        VisualBlurView() // Native blur material backing
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.4), Theme.border.opacity(0.2), .white.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.2
                    )
            )
            .shadow(
                color: Theme.glassShadow.color,
                radius: Theme.glassShadow.radius,
                x: Theme.glassShadow.x,
                y: Theme.glassShadow.y
            )
    }
}

// Native blur material view wrapper that works cross-platform
struct VisualBlurView: View {
    var body: some View {
        #if os(macOS)
        VisualEffectViewMac()
        #else
        Color.white.opacity(0.3)
            .background(.ultraThinMaterial)
        #endif
    }
}

#if os(macOS)
struct VisualEffectViewMac: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .withinWindow
        view.state = .active
        view.material = .hudWindow
        return view
    }
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
#endif

// MARK: - Optimized Lift Modifier (Resolves Scroll Locking)
struct LuxuryPerspectiveTiltModifier: ViewModifier {
    @State private var isHovering = false
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.97 : (isHovering ? 1.025 : 1.0))
            .shadow(
                color: Theme.primarySlate.opacity(isPressed ? 0.04 : (isHovering ? 0.09 : 0.03)),
                radius: isPressed ? 8 : (isHovering ? 16 : 10),
                x: 0,
                y: isPressed ? 4 : (isHovering ? 8 : 6)
            )
            .animation(Theme.quickSpring, value: isHovering)
            .animation(Theme.quickSpring, value: isPressed)
            #if os(macOS)
            .onHover { hovering in
                isHovering = hovering
            }
            #endif
            .onLongPressGesture(minimumDuration: 0.0, pressing: { pressing in
                isPressed = pressing
            }, perform: {})
    }
}

// MARK: - View Extensions
extension View {
    func glassCardStyle() -> some View {
        self.modifier(GlassmorphicCard())
    }
    
    func luxury3DTilt() -> some View {
        self.modifier(LuxuryPerspectiveTiltModifier())
    }
}
