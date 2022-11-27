import Foundation
import struct SwiftUI.NavigationPath

/// USAGE: calling the `navigateDetail` with the dataType of the detail type will navigate to detail view.
final class MediaNavigationCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    func navigateDetail(media: Media) {
        navigationPath.append(media)
    }
}
