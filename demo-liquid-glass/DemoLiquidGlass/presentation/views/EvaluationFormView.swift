import SwiftUI

/// Screen 3: Peer Evaluation Form
/// Step wizard with GlassScoreSelector — per-criteria scoring.
/// Uses .glassEffect(.regular.interactive()) for haptic press response.
/// Light theme: systemGroupedBackground, dark text, blue accents.
struct EvaluationFormView: View {
    let assessment: Assessment
    @Environment(AppState.self) private var appState
    @State private var navigateToResults = false

    private var peers: [Peer] { appState.peers(for: assessment) }
    private var currentPeer: Peer? { peers[safe: appState.currentPeerIndex] }
    private var isLastPeer: Bool { appState.currentPeerIndex >= peers.count - 1 }
    private var progress: Double {
        guard !peers.isEmpty else { return 0 }
        return Double(appState.currentPeerIndex) / Double(peers.count)
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                progressHeader
                if let peer = currentPeer {
                    ScrollView {
                        VStack(spacing: 28) {
                            peerHeader(peer: peer)
                            scoringSection(peer: peer)
                            actionButton(peer: peer)
                        }
                        .padding(20)
                    }
                }
            }
        }
        .navigationTitle("Evaluación")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToResults) {
            ResultsView(assessment: assessment)
        }
    }

    // MARK: - Subviews

    private var progressHeader: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Compañero \(appState.currentPeerIndex + 1) de \(peers.count)")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption.bold())
                    .foregroundStyle(.tertiary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(.systemFill))
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.brand)
                        .frame(width: geo.size.width * progress)
                        .animation(.spring(response: 0.4), value: progress)
                }
            }
            .frame(height: 4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }

    private func peerHeader(peer: Peer) -> some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.brand.opacity(0.12))
                    .frame(width: 80, height: 80)
                Text(peer.initials)
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.brand)
            }
            Text(peer.name)
                .font(.title2.bold())
                .foregroundStyle(.primary)
            Text("Evalúa el desempeño de \(peer.name.components(separatedBy: " ").first ?? peer.name)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 16)
    }

    private func scoringSection(peer: Peer) -> some View {
        VStack(spacing: 20) {
            ForEach(appState.criteria) { crit in
                CriteriaScoringRow(
                    criteria: crit,
                    score: Binding(
                        get: { appState.currentEvaluationScores[peer.id]?[crit.id] ?? 3 },
                        set: { appState.setScore($0, forCriteria: crit.id, peer: peer.id) }
                    )
                )
            }
        }
    }

    private func actionButton(peer: Peer) -> some View {
        Button {
            advanceToNext()
        } label: {
            Label(
                isLastPeer ? "Ver Resultados" : "Siguiente compañero",
                systemImage: isLastPeer ? "chart.bar.fill" : "arrow.right"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .tint(.brand)
        .disabled(!appState.isComplete(for: peer.id))
    }

    // MARK: - Actions

    private func advanceToNext() {
        if isLastPeer {
            appState.loadResults(for: assessment.id)
            navigateToResults = true
        } else {
            withAnimation(.spring(response: 0.35)) {
                appState.currentPeerIndex += 1
            }
        }
    }
}

// MARK: - Criteria Scoring Row

private struct CriteriaScoringRow: View {
    let criteria: Criteria
    @Binding var score: Int

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                Circle()
                    .fill(Color.brand.opacity(0.5))
                    .frame(width: 8, height: 8)
                VStack(alignment: .leading, spacing: 2) {
                    Text(criteria.name)
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                    Text(criteria.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                Spacer()
                Text(String(format: "%.0f%%", criteria.weight * 100))
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
            }
            GlassScoreSelector(selectedScore: $score, scores: [2, 3, 4, 5])
            Text(scoreLabel(for: score))
                .font(.caption)
                .foregroundStyle(.secondary)
                .animation(.easeInOut, value: score)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private func scoreLabel(for score: Int) -> String {
        switch score {
        case 2: return "Por mejorar"
        case 3: return "Cumple con lo esperado"
        case 4: return "Supera las expectativas"
        case 5: return "Excelente desempeño"
        default: return ""
        }
    }
}

// MARK: - Array safe subscript

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    let repo = AssessmentRepository(source: LocalAssessmentSource())
    let state = AppState(repository: repo)
    NavigationStack {
        EvaluationFormView(assessment: state.assessments.first!)
    }
    .environment(state)
}
