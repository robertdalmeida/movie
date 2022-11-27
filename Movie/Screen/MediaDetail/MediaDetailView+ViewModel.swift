import Foundation

extension MediaDetailView {
    @MainActor
    final class ViewModel: ObservableObject {
        let media: Media
        let favoriteStoreService: FavoritesStore
        
        enum FavoriteButtonState {
            case notAFavorite
            case favorite
            case inProgress
        }
        
        @Published var favoriteButtonState: FavoriteButtonState = .notAFavorite
        
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
        
        var userRating: Double {
            (media.voteAverage ?? 0) * 0.1
        }
        
        init(media: Media, favoriteStoreService: FavoritesStore, offline: Bool) {
            self.media = media
            self.favoriteStoreService = favoriteStoreService
            self.offline = offline
            checkFavorite()
        }
        
        // MARK: -  Favorite Button State
        func checkFavorite() {
            self.favoriteButtonState = favoriteStoreService.isMediaAFavorite(media: media) ? .favorite : .notAFavorite
        }
        
        func favoriteButtonTapped() async {
            self.favoriteButtonState = .inProgress
            do {
                if favoriteStoreService.isMediaAFavorite(media: media) {
                    try await favoriteStoreService.removeFavorite(media: media)
                } else {
                    try await favoriteStoreService.saveFavorite(media: media)
                }
                checkFavorite()
            } catch {
                // TODO: Error handling if something doesn't change.
            }
        }
    }
}
