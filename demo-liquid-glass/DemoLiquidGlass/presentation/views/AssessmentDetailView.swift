import SwiftUI

/// Screen 2: Assessment Detail
/// Full-bleed hero with soft blue/indigo gradient over white;
/// criteria pills with .glassEffect(.regular).tint(color);
/// peer avatars in GlassEffectContainer horizontal scroll.
/// Navigation bar "···" button opens a Liquid Glass contextual menu.
struct AssessmentDetailView: View {
    let assessment: Assessment
    @Environment(AppState.self) private var appState
    @State private var navigateToForm = false
    @State private var navigateToResults = false
    @State private var showReportAlert = false

    private var pillColors: [Color] { Color.criteriaColors }

    private var peers: [Peer] {
        appState.peers(for: assessment)
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Page background
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            heroBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Spacer for hero overlap
                    Spacer().frame(height: 220)

                    VStack(alignment: .leading, spacing: 20) {
                        deadlineSection
                        criteriaSection
                        peerSection
                        startButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationTitle(assessment.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // Native Menu — anchors near the button, gets Liquid Glass on iOS 26 automatically
                Menu {
                    Button {
                        showReportAlert = true
                    } label: {
                        Label("Reportar problema", systemImage: "exclamationmark.bubble")
                    }
                    Button {
                        navigateToResults = true
                    } label: {
                        Label("Ver resultados previos", systemImage: "chart.bar.xaxis")
                    }
                    Divider()
                    Button(role: .destructive) {
                        appState.resetEvaluationForm()
                    } label: {
                        Label("Reiniciar evaluación", systemImage: "arrow.counterclockwise")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .navigationDestination(isPresented: $navigateToForm) {
            EvaluationFormView(assessment: assessment)
        }
        .navigationDestination(isPresented: $navigateToResults) {
            ResultsView(assessment: assessment)
        }
        .alert("Reportar problema", isPresented: $showReportAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Enviar reporte") {}
        } message: {
            Text("Se enviará un reporte sobre esta evaluación al administrador del curso.")
        }
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Subviews

    private var heroBackground: some View {
        LinearGradient(
            stops: [
                .init(color: Color.brand.opacity(0.10), location: 0),
                .init(color: Color.brand.opacity(0.06), location: 0.6),
                .init(color: Color(.systemGroupedBackground), location: 1),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 280)
        .overlay(alignment: .bottom) {
            // Subtle decorative blobs
            ZStack {
                Circle()
                    .fill(Color.brand.opacity(0.08))
                    .frame(width: 200, height: 200)
                    .offset(x: -60, y: 30)
                    .blur(radius: 40)
                Circle()
                    .fill(Color.brand.opacity(0.05))
                    .frame(width: 150, height: 150)
                    .offset(x: 80, y: 10)
                    .blur(radius: 30)
            }
        }
    }

    private var deadlineSection: some View {
        HStack {
            Image(systemName: "calendar")
                .foregroundStyle(.secondary)
            Text("Fecha límite: \(assessment.deadline)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var criteriaSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Criterios de evaluación")
                .font(.headline)
                .foregroundStyle(.primary)

            Group {
                if #available(iOS 26, *) {
                    // TRUE LIQUID GLASS criteria pills with color tinting
                    GlassEffectContainer(spacing: 8) {
                        FlowLayout(spacing: 8) {
                            ForEach(Array(appState.criteria.enumerated()), id: \.element.id) { index, crit in
                                CriteriaPill(criteria: crit, color: pillColors[index % pillColors.count])
                                    .glassEffect(
                                        Glass.regular.tint(pillColors[index % pillColors.count].opacity(0.3)),
                                        in: Capsule()
                                    )
                            }
                        }
                    }
                } else {
                    // FALLBACK — NOT Liquid Glass
                    FlowLayout(spacing: 8) {
                        ForEach(Array(appState.criteria.enumerated()), id: \.element.id) { index, crit in
                            CriteriaPill(criteria: crit, color: pillColors[index % pillColors.count])
                                .background(
                                    Capsule().fill(
                                        pillColors[index % pillColors.count].opacity(0.12)
                                    ) // NOT Liquid Glass
                                )
                        }
                    }
                }
            }
        }
    }

    private var peerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Compañeros a evaluar")
                .font(.headline)
                .foregroundStyle(.primary)

            ScrollView(.horizontal, showsIndicators: false) {
                Group {
                    if #available(iOS 26, *) {
                        // TRUE LIQUID GLASS peer avatar row
                        GlassEffectContainer(spacing: 12) {
                            HStack(spacing: 12) {
                                ForEach(peers) { peer in
                                    PeerAvatar(peer: peer)
                                        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    } else {
                        // FALLBACK — NOT Liquid Glass
                        HStack(spacing: 12) {
                            ForEach(peers) { peer in
                                PeerAvatar(peer: peer)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial) // NOT Liquid Glass
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal, 1) // prevent clip
            }
        }
    }

    private var startButton: some View {
        Button {
            appState.resetEvaluationForm()
            navigateToForm = true
        } label: {
            Label("Comenzar Evaluación", systemImage: "pencil.and.list.clipboard")
                .font(.subheadline.bold())
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
        }
        .buttonStyle(.borderedProminent)
        .tint(.brand)
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }
}

// MARK: - Supporting Views

private struct CriteriaPill: View {
    let criteria: Criteria
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(criteria.name)
                .font(.caption.bold())
                .foregroundStyle(.primary)
            Text(String(format: "%.0f%%", criteria.weight * 100))
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}

private struct PeerAvatar: View {
    let peer: Peer

    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(Color.brand.opacity(0.12))
                    .frame(width: 40, height: 40)
                Text(peer.initials)
                    .font(.subheadline.bold())
                    .foregroundStyle(Color.brand)
            }
            Text(peer.name.components(separatedBy: " ").first ?? peer.name)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(width: 60)
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
    }
}

/// Simple flow layout for criteria pills
private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width,
                                subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY),
                proposal: ProposedViewSize(frame.size)
            )
        }
    }

    private struct FlowResult {
        var size: CGSize = .zero
        var frames: [CGRect] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0
            var maxX: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if x + size.width > maxWidth, x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }
                frames.append(CGRect(origin: CGPoint(x: x, y: y), size: size))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
                maxX = max(maxX, x - spacing)
            }
            self.size = CGSize(width: maxX, height: y + rowHeight)
        }
    }
}

#Preview {
    let repo = AssessmentRepository(source: LocalAssessmentSource())
    let state = AppState(repository: repo)
    NavigationStack {
        AssessmentDetailView(assessment: state.assessments.first!)
    }
    .environment(state)
}
