import SwiftUI

/// Screen 1: Dashboard / Home
/// Shows course cards using GlassEffectContainer + .glassEffect(.regular) (iOS 26+)
/// with a clean white/light background — Apple Music aesthetic.
struct HomeView: View {
    @Environment(AppState.self) private var appState
    @State private var navigateToAssessment = false

    var body: some View {
        @Bindable var state = appState
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    courseCardsSection
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("PeerAssess")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Assessment.self) { assessment in
                AssessmentDetailView(assessment: assessment)
            }
        }
    }

    // MARK: - Subviews

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Bienvenido")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("Mis Cursos")
                .font(.title2.bold())
                .foregroundStyle(.primary)
        }
    }

    private var courseCardsSection: some View {
        VStack(spacing: 16) {
            if #available(iOS 26, *) {
                // TRUE LIQUID GLASS — GlassEffectContainer merges overlapping glass shapes
                GlassEffectContainer {
                    VStack(spacing: 16) {
                        ForEach(appState.courses) { course in
                            NavigationLink(value: appState.assessments(for: course.id).first) {
                                CourseCardContent(course: course)
                            }
                            .buttonStyle(.plain)
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20))
                        }
                    }
                }
            } else {
                // FALLBACK — NOT Liquid Glass (iOS 15 material blur)
                VStack(spacing: 16) {
                    ForEach(appState.courses) { course in
                        NavigationLink(value: appState.assessments(for: course.id).first) {
                            CourseCardContent(course: course)
                        }
                        .buttonStyle(.plain)
                        .background(
                            RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial) // NOT Liquid Glass
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Course Card Content

private struct CourseCardContent: View {
    let course: Course

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.brand.opacity(0.12))
                    .frame(width: 48, height: 48)
                Text(String(course.name.prefix(2)).uppercased())
                    .font(.headline.bold())
                    .foregroundStyle(Color.brand)
            }

            // Course info
            VStack(alignment: .leading, spacing: 4) {
                Text(course.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Text("\(course.semester) · \(course.studentCount) estudiantes")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Código: \(course.enrollmentCode)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(.tertiary)
        }
        .padding(16)
    }
}

#Preview {
    let repo = AssessmentRepository(source: LocalAssessmentSource())
    let state = AppState(repository: repo)
    HomeView()
        .environment(state)
}
