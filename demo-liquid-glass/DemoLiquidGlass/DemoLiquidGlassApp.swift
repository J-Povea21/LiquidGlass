import SwiftUI

/// App entry point — Dependency Injection happens here.
/// The data layer (AssessmentRepository) is created once and injected into AppState.
/// AppState only knows about the domain protocol (AssessmentRepositoryProtocol).
@main
struct DemoLiquidGlassApp: App {
    @State private var appState: AppState = {
        // DI: compose the dependency graph at the composition root
        let localSource = LocalAssessmentSource()
        let repository = AssessmentRepository(source: localSource)
        return AppState(repository: repository)
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
        }
    }
}

/// Root navigation structure with TabView.
/// On iOS 26+, TabView gets native Liquid Glass tab bar styling automatically.
/// Uses iOS 17-compatible TabView syntax (tag-based, not value-based).
struct RootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var state = appState
        TabView(selection: $state.selectedTab) {
            HomeView()
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }
                .tag(0)

            AssessmentsListView()
                .tabItem {
                    Label("Evaluaciones", systemImage: "list.clipboard.fill")
                }
                .tag(1)

            QuickResultsView()
                .tabItem {
                    Label("Resultados", systemImage: "chart.bar.fill")
                }
                .tag(2)
        }
        // On iOS 26+, TabView automatically gets Liquid Glass tab bar styling.
        // No additional modifier needed — it is the system default.
    }
}

/// Simple assessments list tab — uses Liquid Glass cards on iOS 26+
struct AssessmentsListView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    if #available(iOS 26, *) {
                        GlassEffectContainer {
                            VStack(spacing: 12) {
                                ForEach(appState.assessments) { assessment in
                                    NavigationLink {
                                        AssessmentDetailView(assessment: assessment)
                                    } label: {
                                        AssessmentRowContent(assessment: assessment)
                                    }
                                    .buttonStyle(.plain)
                                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                                }
                            }
                        }
                    } else {
                        // FALLBACK — NOT Liquid Glass
                        ForEach(appState.assessments) { assessment in
                            NavigationLink {
                                AssessmentDetailView(assessment: assessment)
                            } label: {
                                AssessmentRowContent(assessment: assessment)
                            }
                            .buttonStyle(.plain)
                            .background(
                                RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground))
                            )
                        }
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Evaluaciones")
        }
    }
}

private struct AssessmentRowContent: View {
    let assessment: Assessment

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.brand.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: "list.clipboard.fill")
                    .foregroundStyle(Color.brand)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(assessment.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Text("Límite: \(assessment.deadline)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(.tertiary)
        }
        .padding(14)
    }
}

/// Quick results overview tab — shows results for the selected assessment
struct QuickResultsView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedIndex: Int = 0

    /// Short display title: part before " — " if present, otherwise first word.
    private func shortTitle(for assessment: Assessment) -> String {
        if let range = assessment.title.range(of: " — ") {
            return String(assessment.title[assessment.title.startIndex ..< range.lowerBound])
        }
        return assessment.title.components(separatedBy: " ").first ?? assessment.title
    }

    var body: some View {
        NavigationStack {
            if appState.assessments.isEmpty {
                ContentUnavailableView(
                    "Sin evaluaciones",
                    systemImage: "chart.bar.xaxis",
                    description: Text("Completa una evaluación para ver resultados")
                )
                .navigationTitle("Resultados")
            } else {
                let selectedAssessment = appState.assessments[selectedIndex]
                VStack(spacing: 0) {
                    Picker("Evaluación", selection: $selectedIndex) {
                        ForEach(appState.assessments.indices, id: \.self) { i in
                            Text(shortTitle(for: appState.assessments[i])).tag(i)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    ResultsView(assessment: selectedAssessment)
                        .task(id: selectedIndex) {
                            appState.loadResults(for: selectedAssessment.id)
                        }
                }
                .navigationTitle("Resultados")
            }
        }
    }
}
