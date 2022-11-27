import SwiftUI

final class AppDependencies: ObservableObject {
    let storeService: TMDbStoreService
    let favoriteService: FavoritesStore

    init(storeService: TMDbStoreService = TMDbStoreService(),
         favoriteService: FavoritesStore = FavoritesStore()) {
        self.storeService = storeService
        self.favoriteService = favoriteService
    }
    
#if DEBUG
    static let mock = AppDependencies(storeService: .mock(), favoriteService: .mock)
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
