//
//  Models.swift
//  Palet Crm
//
//  Created by Antigravity on 25.06.2026.
//

import Foundation

// MARK: - KPI Model
struct KPICardData: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let detail: String
    let trend: String
    let isPositive: Bool?
    let iconName: String
}

// MARK: - Project Model
enum BudgetStatus: String, Codable {
    case onBudget = "On Budget"
    case overBudget = "Over Budget"
    case underBudget = "Under Budget"
}

struct Project: Identifiable {
    let id = UUID()
    let name: String
    let progress: Double // 0.0 to 1.0
    let budget: Double // In TL
    let budgetStatus: BudgetStatus
    let siteManager: String
    let managerAvatar: String // Image asset name or initials
    let deadline: String
    let location: String
    let description: String
}

// MARK: - Sales Chart Data Point
struct SalesProgressDataPoint: Identifiable {
    let id = UUID()
    let month: String
    let salesAmount: Double // In Millions (₺)
    let progressPercent: Double // 0 to 100
}

// MARK: - Funnel Stage Model
struct FunnelStage: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
    let rate: Double // Conversion rate from previous stage
    let overallRate: Double // Conversion rate from start
    let colorHex: String
}

// MARK: - Client Model
struct Client: Identifiable {
    let id = UUID()
    let name: String
    let contactPerson: String
    let email: String
    let phone: String
    let status: String // "Active", "Lead", "Negotiating", "Contract Signed"
    let totalRevenue: Double
}

// MARK: - Mock Data Controller
class MockData {
    static let shared = MockData()
    
    // Core KPIs
    let kpiCards: [KPICardData] = [
        KPICardData(
            title: "Active Projects",
            value: "12",
            detail: "+2 this month",
            trend: "16.7%",
            isPositive: true,
            iconName: "square.grid.3x3.fill"
        ),
        KPICardData(
            title: "Total Sales",
            value: "₺4.5M",
            detail: "vs ₺4.0M target",
            trend: "12.5%",
            isPositive: true,
            iconName: "turkishlirasign.circle.fill"
        ),
        KPICardData(
            title: "New Leads",
            value: "85",
            detail: "24 require follow-up",
            trend: "Pending",
            isPositive: nil,
            iconName: "person.crop.circle.badge.plus"
        ),
        KPICardData(
            title: "Site Status",
            value: "8 / 2",
            detail: "8 on track / 2 delayed",
            trend: "80%",
            isPositive: false,
            iconName: "exclamationmark.triangle.fill"
        )
    ]
    
    // Sales and Progress chart (12 months data)
    let monthlyData: [SalesProgressDataPoint] = [
        SalesProgressDataPoint(month: "Jan", salesAmount: 1.2, progressPercent: 12.0),
        SalesProgressDataPoint(month: "Feb", salesAmount: 1.5, progressPercent: 18.0),
        SalesProgressDataPoint(month: "Mar", salesAmount: 1.8, progressPercent: 25.0),
        SalesProgressDataPoint(month: "Apr", salesAmount: 2.1, progressPercent: 32.0),
        SalesProgressDataPoint(month: "May", salesAmount: 2.4, progressPercent: 40.0),
        SalesProgressDataPoint(month: "Jun", salesAmount: 3.0, progressPercent: 48.0),
        SalesProgressDataPoint(month: "Jul", salesAmount: 2.8, progressPercent: 55.0),
        SalesProgressDataPoint(month: "Aug", salesAmount: 3.2, progressPercent: 62.0),
        SalesProgressDataPoint(month: "Sep", salesAmount: 3.5, progressPercent: 70.0),
        SalesProgressDataPoint(month: "Oct", salesAmount: 3.9, progressPercent: 78.0),
        SalesProgressDataPoint(month: "Nov", salesAmount: 4.2, progressPercent: 85.0),
        SalesProgressDataPoint(month: "Dec", salesAmount: 4.5, progressPercent: 92.0)
    ]
    
    // Critical Projects
    let criticalProjects: [Project] = [
        Project(
            name: "Oak Street Luxury Condos",
            progress: 0.74,
            budget: 1200000.0,
            budgetStatus: .onBudget,
            siteManager: "Savaş Mert",
            managerAvatar: "SM",
            deadline: "15 Oct 2026",
            location: "Beşiktaş, Istanbul",
            description: "High-end residential complex with 45 boutique apartments, featuring panoramic Bosphorus views and sustainable green infrastructure."
        ),
        Project(
            name: "Metro General Hospital Wing",
            progress: 0.48,
            budget: 2800000.0,
            budgetStatus: .onBudget,
            siteManager: "Can Yılmaz",
            managerAvatar: "CY",
            deadline: "20 Dec 2026",
            location: "Kadıköy, Istanbul",
            description: "An expansion of the existing general hospital, incorporating state-of-the-art surgical suites and energy-efficient climate control systems."
        ),
        Project(
            name: "Industrial Logistics Park",
            progress: 0.92,
            budget: 4100000.0,
            budgetStatus: .overBudget,
            siteManager: "Ayşe Kaya",
            managerAvatar: "AK",
            deadline: "10 Sep 2026",
            location: "Gebze, Kocaeli",
            description: "Massive warehouse complex and distribution center optimized for electric logistics fleets, including automated sorting hubs."
        ),
        Project(
            name: "Riverfront Premium Hotel",
            progress: 0.30,
            budget: 6500000.0,
            budgetStatus: .onBudget,
            siteManager: "Demir Demir",
            managerAvatar: "DD",
            deadline: "05 Mar 2027",
            location: "Sarıyer, Istanbul",
            description: "A 5-star hotel structure with floating docks, luxury wellness spas, and architectural facades reflecting classic Ottoman elements."
        ),
        Project(
            name: "Vadi Residences Phase 2",
            progress: 0.15,
            budget: 8200000.0,
            budgetStatus: .underBudget,
            siteManager: "Ahmet Yılmaz",
            managerAvatar: "AY",
            deadline: "12 Jul 2027",
            location: "Seyrantepe, Istanbul",
            description: "A continuation of the successful Vadi Valley project, including 3 high-rise residential towers and retail plazas."
        )
    ]
    
    // Funnel stages (Intro -> Offer -> Negotiation -> Contract)
    let funnelStages: [FunnelStage] = [
        FunnelStage(name: "Intro", count: 120, rate: 100.0, overallRate: 100.0, colorHex: "2C3E50"),
        FunnelStage(name: "Offer", count: 75, rate: 62.5, overallRate: 62.5, colorHex: "E67E22"),
        FunnelStage(name: "Negotiation", count: 38, rate: 50.7, overallRate: 31.6, colorHex: "3498DB"),
        FunnelStage(name: "Contract", count: 24, rate: 63.2, overallRate: 20.0, colorHex: "2ECC71")
    ]
    
    // Clients
    let clients: [Client] = [
        Client(name: "Kaya İnşaat A.Ş.", contactPerson: "Mehmet Kaya", email: "mehmet@kayainsaat.com", phone: "+90 212 555 1234", status: "Active", totalRevenue: 12400000.0),
        Client(name: "Demir Group", contactPerson: "Ece Demir", email: "ece@demirgroup.co", phone: "+90 216 444 9876", status: "Negotiation", totalRevenue: 8200000.0),
        Client(name: "Mert Yapı", contactPerson: "Selin Mert", email: "selin@mertyapi.com.tr", phone: "+90 312 333 4567", status: "Active", totalRevenue: 4500000.0),
        Client(name: "Yildiz Holding", contactPerson: "Kemal Yıldız", email: "kemal@yildiz.com", phone: "+90 212 999 8811", status: "Lead", totalRevenue: 15000000.0),
        Client(name: "Global Builders", contactPerson: "Hakan Tan", email: "hakan@globalbuilders.com", phone: "+90 212 888 7766", status: "Contract Signed", totalRevenue: 9800000.0)
    ]
}
