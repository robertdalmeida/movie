import SwiftUI

final class AppDependencies: ObservableObject {
    let mediaStore: MediaStore
    let favoriteStore: FavoritesStore

    init(mediaStore: MediaStore = MediaStore(),
         favoriteStore: FavoritesStore = FavoritesStore()) {
        self.mediaStore = mediaStore
        self.favoriteStore = favoriteStore
    }
    
#if DEBUG
    static let mock = AppDependencies(mediaStore: .mock(), favoriteStore: .mock)
#endif
}

@main
struct MovieApp: App {
    @StateObject var appDependencies = AppDependencies()
    var body: some Scene {
        WindowGroup {
            StartingView(viewModel: .init(appDependencies: appDependencies))
                .environmentObject(appDependencies)
        }
    }
}

#if DEBUG
extension View {
    func configure() -> some View {
        self.environmentObject(AppDependencies())
    }
}
#endif
