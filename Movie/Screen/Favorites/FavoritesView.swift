import SwiftUI
import Combine

struct FavoritesView: View {
    @EnvironmentObject var favoriteStore: FavoritesStore
    @EnvironmentObject var mediaStore: MediaStore
    
    @StateObject var viewModel: ViewModel = .init()
    
    var body: some View {
        VStack {
            Text("Favorites")
                .applyAppStyle(.title)
            
            switch favoriteStore.status {
            case .fetched(mediaContents: let favorites) where favorites.isEmpty:
                Spacer()
                Text("No favorites to display - look for the 💙")
                Spacer()

            case .error:
                Spacer()
                Text("No favorites to display - look for the 💙")
                Spacer()
                
            case .fetched(mediaContents: let favorites):
                favoriteList(favorites: favorites)
            }
        }
    }
    
    func favoriteList(favorites: [Media]) -> some View {
        List {
            ForEach(favorites) { item in
                NavigationLink {
                    MediaDetailView(viewModel: .init(media: item,
                                                     favoriteStore: favoriteStore,
                                                     mediaStore: mediaStore))
                } label: {
                    FavoriteRow(item: item)
                }
            }
            .onDelete { 
                deleteFavorite(at: $0, favoriteStore: favoriteStore)
                
                func deleteFavorite(at offsets: IndexSet, favoriteStore: FavoritesStore) {
                    let objectsToRemove = offsets.map { favorites[$0] }
                    Task {
                        try await objectsToRemove.asyncForEach { media in
                            try await favoriteStore.removeFavorite(media: media)
                        }
                    }
                }

            }
        }
        .listStyle(.insetGrouped)
    }
}

extension FavoritesView {
    final class ViewModel: ObservableObject {
        @Published var favorites: [Media] = []
        private var anyCancellables: [AnyCancellable] = []
        
        enum ViewState {
            case noFavorites
            case loaded
        }
        var state: ViewState = .noFavorites
        
//        init(favoriteStoreService: FavoritesStore) {
//            self.favoriteStoreService = favoriteStoreService
//
////            favoriteStoreService.$status.receive(on: RunLoop.main)
////                .sink { status in
////                    switch status {
////                    case .fetched(mediaContents: let favorites):
////                        self.favorites = favorites
////                        self.state = .loaded
////                    case .error:
////                        self.state = .noFavorites
////                        break
////                    }
////                }.store(in: &anyCancellables)
//        }
        
        
    }
}

#if DEBUG
struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(viewModel: .init())
    }
}
#endif
