import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack{
            if viewModel.offline {
                OfflineIndicator()
                    .transition(.slide)
                    .padding()
            }
            AsyncImage(url: viewModel.image) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }.padding([.bottom])
            HStack {
                VStack {
                    Text(viewModel.title)
                        .applyAppStyle(.title)
                    if let releaseDate = viewModel.releaseDate {
                        Text(releaseDate, style: .date)
                    }
                }
                Spacer()
                Button {
                    viewModel.favoriteButtonTapped()
                } label: {
                    if viewModel.isFavorite {
                        Image(systemName: "heart.fill")
                    } else {
                        Image(systemName: "heart")
                    }
                    
                }
            }
            .padding()
        }.navigationTitle(viewModel.title)
    }
}

extension MovieDetailView {
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
                    
                }
            }
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(viewModel: .init(media: .mock,
                                         favoriteStoreService: .mock, offline: false))
            .configure()
    }
}
