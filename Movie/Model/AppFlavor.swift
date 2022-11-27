import Foundation
import SwiftUI


enum AppThemeColor {
    static let themeColor = Color(.systemGray2)
}

enum AppFontStyle {
    case title
    case cellTitle
    case errorText
    
    var font: Font {
        switch self {
        case .title: return .title
        case .cellTitle: return .subheadline
        case .errorText: return .headline
        }
    }
    
    var fontDesign: Font.Design {
        switch self {
        case .title: return .rounded
        case .cellTitle: return .rounded
        case .errorText: return .monospaced
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
