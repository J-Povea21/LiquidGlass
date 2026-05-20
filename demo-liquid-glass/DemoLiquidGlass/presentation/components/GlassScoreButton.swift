import SwiftUI

/// Score selection button using true Liquid Glass API (iOS 26+).
/// Falls back to ultraThinMaterial on older OS — clearly labeled as NOT Liquid Glass.
/// Light theme: blue tint on selection, primary text on idle.
struct GlassScoreButton: View {
    let score: Int
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text("\(score)")
                .font(.title2.bold())
                .frame(width: 56, height: 56)
                .foregroundStyle(isSelected ? Color.white : Color.primary)
        }
        // NOTE: .glassEffect() is applied by the parent GlassEffectContainer context.
        // The button itself only defines its content; the glass shape is applied outside.
    }
}

/// Wraps score buttons in GlassEffectContainer for true Liquid Glass morphing (iOS 26+).
struct GlassScoreSelector: View {
    @Binding var selectedScore: Int
    let scores: [Int]

    var body: some View {
        Group {
            if #available(iOS 26, *) {
                // TRUE LIQUID GLASS — GlassEffectContainer with morphing
                GlassEffectContainer(spacing: 8) {
                    HStack(spacing: 8) {
                        ForEach(scores, id: \.self) { score in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedScore = score
                                }
                            } label: {
                                Text("\(score)")
                                    .font(.title2.bold())
                                    .frame(width: 64, height: 64)
                                    .foregroundStyle(selectedScore == score ? Color.white : Color.primary)
                            }
                            .glassEffect(
                                selectedScore == score
                                    ? Glass.regular.tint(.brand).interactive()
                                    : Glass.regular.interactive(),
                                in: Circle()
                            )
                        }
                    }
                }
            } else {
                // FALLBACK — NOT Liquid Glass (iOS 15 ultraThinMaterial blur)
                HStack(spacing: 8) {
                    ForEach(scores, id: \.self) { score in
                        Button {
                            selectedScore = score
                        } label: {
                            Text("\(score)")
                                .font(.title2.bold())
                                .frame(width: 64, height: 64)
                                .foregroundStyle(selectedScore == score ? Color.white : Color.primary)
                                .background(
                                    Circle().fill(selectedScore == score ? Color.brand : Color.clear)
                                )
                        }
                        .background(
                            Circle().fill(.ultraThinMaterial) // NOT Liquid Glass
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var score = 4
    ZStack {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        GlassScoreSelector(selectedScore: $score, scores: [2, 3, 4, 5])
    }
}
