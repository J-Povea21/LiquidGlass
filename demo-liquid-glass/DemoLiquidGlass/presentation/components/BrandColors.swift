import SwiftUI

extension Color {
    /// Primary accent — Apple system blue #007AFF
    static let brand = Color(red: 0, green: 122 / 255, blue: 1)
    /// Subtle blue surface for cards/backgrounds
    static let brandSurface = Color(red: 240 / 255, green: 244 / 255, blue: 1)
    /// Score high (5) — green #34C759
    static let scoreHigh = Color(red: 52 / 255, green: 199 / 255, blue: 89 / 255)
    /// Score mid/low (2) — amber #FF9500
    static let scoreMid = Color(red: 1, green: 149 / 255, blue: 0)

    /// Ordered palette for 4 evaluation criteria. Intentional semantic colors,
    /// not positional randoms. Matches Flutter's AppTheme.criteriaColors.
    static let criteriaColors: [Color] = [
        .brand,                                        // #007AFF — Puntualidad
        .scoreHigh,                                    // #34C759 — Contribuciones
        .scoreMid,                                     // #FF9500 — Compromiso
        Color(red: 0.686, green: 0.322, blue: 0.871)  // #AF52DE — Actitud (iOS system violet)
    ]
}
