import Foundation
import SwiftUI


enum AppFontStyle {
    case title
    case cellTitle
    
    var font: Font {
        switch self {
        case .title: return .title
        case .cellTitle: return .subheadline
        }
    }
    
    var fontDesign: Font.Design {
        switch self {
        case .title: return .rounded
        case .cellTitle: return .rounded
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
