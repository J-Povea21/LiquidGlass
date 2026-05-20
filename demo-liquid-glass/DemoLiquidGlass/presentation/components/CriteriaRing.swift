import SwiftUI

/// Canvas-drawn radial arc component showing per-criteria scores.
/// Used in ResultsView to display the breakdown visually.
struct CriteriaRing: View {
    let scores: [String: Double]  // criteria name → score (2–5)
    let size: CGFloat

    private let criteriaOpacities: [Double] = [1.0, 0.75, 0.55, 0.40]

    private var sortedScores: [(name: String, score: Double)] {
        scores.sorted { $0.key < $1.key }.map { (name: $0.key, score: $0.value) }
    }

    var body: some View {
        Canvas { context, canvasSize in
            let center = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
            let outerRadius = min(canvasSize.width, canvasSize.height) / 2 - 8
            let innerRadius = outerRadius * 0.55
            let strokeWidth = outerRadius - innerRadius

            let segmentAngle = 2 * Double.pi / max(Double(sortedScores.count), 1)
            let gap: Double = 0.08  // radians gap between arcs

            for (i, item) in sortedScores.enumerated() {
                let startAngle = Double(i) * segmentAngle - Double.pi / 2 + gap / 2
                let endAngle = startAngle + segmentAngle - gap

                // Score fraction: 0.0 (score=2) to 1.0 (score=5)
                let fraction = (item.score - 2.0) / 3.0
                let filledEnd = startAngle + (endAngle - startAngle) * fraction

                let opacity = criteriaOpacities[i % criteriaOpacities.count]
                let baseColor = Color.criteriaColors[i % Color.criteriaColors.count]
                let color = baseColor.opacity(opacity)

                // Background track (light)
                var trackPath = Path()
                trackPath.addArc(
                    center: center,
                    radius: outerRadius - strokeWidth / 2,
                    startAngle: .radians(startAngle),
                    endAngle: .radians(endAngle),
                    clockwise: false
                )
                context.stroke(
                    trackPath,
                    with: .color(baseColor.opacity(opacity * 0.18)),
                    style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                )

                // Filled arc
                if fraction > 0 {
                    var fillPath = Path()
                    fillPath.addArc(
                        center: center,
                        radius: outerRadius - strokeWidth / 2,
                        startAngle: .radians(startAngle),
                        endAngle: .radians(filledEnd),
                        clockwise: false
                    )
                    context.stroke(
                        fillPath,
                        with: .color(color),
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                    )
                }
            }
        }
        .frame(width: size, height: size)
    }
}

/// Overlay version: CriteriaRing with a glass badge in the center showing overall average.
struct CriteriaRingWithBadge: View {
    let scores: [String: Double]
    let size: CGFloat

    private var average: Double {
        guard !scores.isEmpty else { return 0 }
        return scores.values.reduce(0, +) / Double(scores.count)
    }

    var body: some View {
        ZStack {
            CriteriaRing(scores: scores, size: size)

            // Center badge — Liquid Glass if available
            Group {
                if #available(iOS 26, *) {
                    Text(String(format: "%.1f", average))
                        .font(.title.bold())
                        .foregroundStyle(.primary)
                        .frame(width: size * 0.45, height: size * 0.45)
                        .glassEffect(.regular, in: Circle())
                } else {
                    Text(String(format: "%.1f", average))
                        .font(.title.bold())
                        .foregroundStyle(.primary)
                        .frame(width: size * 0.45, height: size * 0.45)
                        .background(Circle().fill(.ultraThinMaterial)) // NOT Liquid Glass
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()

        CriteriaRingWithBadge(scores: [
            "Puntualidad": 4.0,
            "Contribuciones": 3.5,
            "Compromiso": 4.5,
            "Actitud": 5.0
        ], size: 200)
    }
}
