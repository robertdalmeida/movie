import Foundation

extension MediaDetailView {
    @MainActor
    final class ViewModel: ObservableObject {
        let media: Media
        let favoriteStoreService: FavoritesStore
        
        var offline: Bool = false
        
        var title: String {
            media.title
        }
        var releaseDate: Date? {
            media.releaseDate
        }
        var image: URL? {
            media.image
        }
        
        var isFavorite: Bool {
            favoriteStoreService.isMediaAFavorite(media: media)
        }
        
        init(media: Media, favoriteStoreService: FavoritesStore, offline: Bool) {
            self.media = media
            self.favoriteStoreService = favoriteStoreService
            self.offline = offline
        }
        
        func favoriteButtonTapped() {
            Task {
                do {
                    if isFavorite {
                        try await favoriteStoreService.removeFavorite(media: media)
                    } else {
                        try await favoriteStoreService.saveFavorite(media: media)
                    }
                    objectWillChange.send()

                } catch {
                    // TODO: Error handling if something doesn't change.
                }
            }
        }
    }
}
