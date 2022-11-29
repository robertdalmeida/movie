import SwiftUI

@main
struct MovieApp: App {
    @StateObject var mediaStore = MediaStore()
    @StateObject var favoriteStore = FavoritesStore()
    @StateObject var imageStoreService = ImageStore()

    var body: some Scene {
        WindowGroup {
            StartingView()
                .environmentObject(imageStoreService)
                .environmentObject(favoriteStore)
                .environmentObject(mediaStore)
        }
    }
}
