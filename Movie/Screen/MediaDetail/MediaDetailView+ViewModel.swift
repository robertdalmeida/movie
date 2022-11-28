import Foundation

extension MediaDetailView {
    @MainActor
    final class ViewModel: ObservableObject {
        let media: Media
        let favoriteStore: FavoritesStore
        let mediaStore: MediaStore

        enum FavoriteButtonState {
            case notAFavorite
            case favorite
            case inProgress
        }
        
        @Published var favoriteButtonState: FavoriteButtonState = .notAFavorite
        
        var title: String {
            media.title
        }
        var releaseDate: Date? {
            media.releaseDate
        }
        var posterImage: ImageSource {
            print("BOB: \(media.posterImage)")
            return media.posterImage
        }
        
        var userRating: Double {
            (media.voteAverage ?? 0) * 0.1
        }
        
        init(media: Media, favoriteStore: FavoritesStore, mediaStore: MediaStore) {
            self.media = media
            self.favoriteStore = favoriteStore
            self.mediaStore = mediaStore
            checkFavorite()
        }
        
        // MARK: -  Favorite Button State
        func checkFavorite() {
            self.favoriteButtonState = favoriteStore.isMediaAFavorite(media: media) ? .favorite : .notAFavorite
        }
        
        func favoriteButtonTapped() async {
            self.favoriteButtonState = .inProgress
            do {
                if favoriteStore.isMediaAFavorite(media: media) {
                    try await favoriteStore.removeFavorite(media: media)
                } else {
                    try await favoriteStore.saveFavorite(media: media)
                }
                checkFavorite()
            } catch {
                // TODO: Error handling if something doesn't change.
            }
        }
    }
}
