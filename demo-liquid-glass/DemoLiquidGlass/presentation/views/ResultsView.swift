import SwiftUI

/// Screen 4: Results / Analytics
/// Score badge with layered GlassEffectContainer rings;
/// Canvas-drawn radial arcs with glass overlay.
/// Light theme: white background, blue/indigo arcs, dark text.
struct ResultsView: View {
    let assessment: Assessment
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 28) {
                    titleSection
                    if appState.results.isEmpty {
                        emptyState
                    } else {
                        podiumSection
                        allResultsList
                    }
                    Spacer(minLength: 40)
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Subviews

    private var titleSection: some View {
        VStack(spacing: 6) {
            Text(assessment.title)
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Resultados de la evaluación")
                .font(.title2.bold())
                .foregroundStyle(.primary)
        }
        .padding(.top, 8)
    }

    /// Top-ranked member with full ring visualization
    private var podiumSection: some View {
        Group {
            if let top = appState.results.first {
                VStack(spacing: 20) {
                    // Layered glass rings with criteria breakdown
                    ZStack {
                        CriteriaRingWithBadge(scores: top.scores, size: 220)
                    }
                    .padding(.top, 8)

                    topMemberBadge(result: top)
                }
            }
        }
    }

    private func topMemberBadge(result: MemberResult) -> some View {
        Group {
            if #available(iOS 26, *) {
                // TRUE LIQUID GLASS layered badge
                GlassEffectContainer(spacing: 0) {
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.yellow.opacity(0.15))
                                    .frame(width: 52, height: 52)
                                Text(result.peer.initials)
                                    .font(.title2.bold())
                                    .foregroundStyle(Color(.systemOrange))
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: "trophy.fill")
                                        .foregroundStyle(.yellow)
                                        .font(.caption)
                                    Text("Mejor evaluado")
                                        .font(.caption.bold())
                                        .foregroundStyle(Color(.systemOrange))
                                }
                                Text(result.peer.name)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                            }
                            Spacer()
                            Text(String(format: "%.1f", result.average))
                                .font(.largeTitle.bold())
                                .foregroundStyle(Color.brand)
                        }
                        criteriaBreakdown(scores: result.scores)
                    }
                    .padding(20)
                    .glassEffect(Glass.regular.tint(.yellow.opacity(0.08)), in: RoundedRectangle(cornerRadius: 24))
                }
            } else {
                // FALLBACK — NOT Liquid Glass
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.yellow.opacity(0.15))
                                .frame(width: 52, height: 52)
                            Text(result.peer.initials)
                                .font(.title2.bold())
                                .foregroundStyle(Color(.systemOrange))
                        }
                        VStack(alignment: .leading) {
                            Text("Mejor evaluado")
                                .font(.caption.bold())
                                .foregroundStyle(Color(.systemOrange))
                            Text(result.peer.name)
                                .font(.headline)
                                .foregroundStyle(.primary)
                        }
                        Spacer()
                        Text(String(format: "%.1f", result.average))
                            .font(.largeTitle.bold())
                            .foregroundStyle(Color.brand)
                    }
                    criteriaBreakdown(scores: result.scores)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 24).fill(Color(.systemBackground)) // NOT Liquid Glass
                )
            }
        }
    }

    private var allResultsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Todos los resultados")
                .font(.headline)
                .foregroundStyle(.primary)

            Group {
                if #available(iOS 26, *) {
                    GlassEffectContainer(spacing: 8) {
                        VStack(spacing: 8) {
                            ForEach(Array(appState.results.enumerated()), id: \.element.id) { index, result in
                                ResultRow(result: result, rank: index + 1)
                                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
                } else {
                    VStack(spacing: 8) {
                        ForEach(Array(appState.results.enumerated()), id: \.element.id) { index, result in
                            ResultRow(result: result, rank: index + 1)
                                .background(
                                    RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)) // NOT Liquid Glass
                                )
                        }
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.bar.xaxis")
                .font(.largeTitle)
                .foregroundStyle(.tertiary)
            Text("No hay resultados aún")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }

    private func criteriaBreakdown(scores: [String: Double]) -> some View {
        VStack(spacing: 6) {
            ForEach(scores.sorted(by: { $0.key < $1.key }), id: \.key) { name, score in
                HStack {
                    Text(name)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    // Score bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.brand.opacity(0.12))
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.brand)
                                .frame(width: geo.size.width * ((score - 2) / 3))
                        }
                    }
                    .frame(width: 80, height: 6)
                    Text(String(format: "%.1f", score))
                        .font(.caption.bold())
                        .foregroundStyle(.primary)
                        .frame(width: 28, alignment: .trailing)
                }
            }
        }
    }
}

// MARK: - Result Row

private struct ResultRow: View {
    let result: MemberResult
    let rank: Int

    private var rankColor: Color {
        switch rank {
        case 1: return Color(.systemOrange)
        case 2: return .secondary
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.2)
        default: return Color(.tertiaryLabel)
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            Text("\(rank)")
                .font(.headline.bold())
                .foregroundStyle(rankColor)
                .frame(width: 24)

            ZStack {
                Circle()
                    .fill(Color.brand.opacity(0.10))
                    .frame(width: 40, height: 40)
                Text(result.peer.initials)
                    .font(.callout.bold())
                    .foregroundStyle(Color.brand)
            }

            Text(result.peer.name)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .lineLimit(1)

            Spacer()

            Text(String(format: "%.1f", result.average))
                .font(.headline.bold())
                .foregroundStyle(Color.brand)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    let repo = AssessmentRepository(source: LocalAssessmentSource())
    let state = AppState(repository: repo)
    state.loadResults(for: "assess-1")
    return NavigationStack {
        ResultsView(assessment: state.assessments.first!)
    }
    .environment(state)
}
