import Foundation
import SwiftUI

enum FeatureToggle {
    static let useUnPagedCardCarousel = false
}

enum AppThemeColor {
    static let themeColor = Color(.systemGray2)
}

enum AppFontStyle {
    case title
    case sectionTitle

    case cellTitle
    case errorText
    case readingContent
    
    var font: Font {
        switch self {
        case .title: return .title
        case .sectionTitle: return .title2

        case .cellTitle: return .subheadline
        case .errorText: return .headline
        case .readingContent: return .footnote
        }
    }
    
    var fontDesign: Font.Design {
        switch self {
        case .title: return .rounded
        case .sectionTitle: return .rounded
        case .cellTitle: return .rounded
        case .errorText: return .monospaced
        case .readingContent: return .default
        }
    }
}


extension View {
    func applyAppStyle(_ style: AppFontStyle) -> some View {
        self.fontDesign(style.fontDesign)
            .font(style.font)
            .bold()
    }
}
