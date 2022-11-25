import Foundation
import SwiftUI


enum AppFontStyle {
    case title
    
    var font: Font {
        switch self {
        case .title: return .title
        }
    }
    
    var fontDesign: Font.Design {
        switch self {
        case .title: return .rounded
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
