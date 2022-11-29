import SwiftUI
import Combine

struct FavoritesView: View {
    @EnvironmentObject var appDependencies: AppDependencies
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("Favorites")
                .applyAppStyle(.title)
            switch viewModel.state {
            case .noFavorites:
                Spacer()
                Text("No favorites to display - look for the 💙")
                Spacer()
            case .loaded:
                listOfFavorites
            }
        }
    }
    
    var listOfFavorites: some View {
        List {
            ForEach(viewModel.favorites) { item in
                NavigationLink {
                    MediaDetailView(viewModel: .init(media: item,
                                                     favoriteStore: appDependencies.favoriteStore,
                                                     mediaStore: appDependencies.mediaStore))
                } label: {
                    FavoriteRow(item: item)
                }
            }
            .onDelete(perform: viewModel.deleteFavorite(at:))
        }
        .listStyle(.insetGrouped)
    }
}

extension FavoritesView {
    final class ViewModel: ObservableObject {
        @Published var favorites: [Media] = []
        let favoriteStoreService: FavoritesStore
        private var anyCancellables: [AnyCancellable] = []
        
        enum State {
            case noFavorites
            case loaded
        }
        @Published var state: State = .noFavorites
        
        init(favoriteStoreService: FavoritesStore) {
            self.favoriteStoreService = favoriteStoreService

            favoriteStoreService.$status.receive(on: RunLoop.main)
                .sink { status in
                    switch status {
                    case .fetched(mediaContents: let favorites):
                        self.favorites = favorites
                        self.state = .loaded
                    case .notInitialized, .error:
                        self.state = .noFavorites
                        break
                    }
                }.store(in: &anyCancellables)
        }
        
        func deleteFavorite(at offsets: IndexSet) {
            let objectsToRemove = offsets.map { favorites[$0] }
            Task {
                try objectsToRemove.forEach { media in
                    try favoriteStoreService.removeFavorite(media: media)
                }
            }
        }
        
        
        #if DEBUG
        static var mock: ViewModel = {
            let model = ViewModel(favoriteStoreService: FavoritesStore())
            model.favorites = [.mock, .mock1, .mock2]
            return model
        }()
        #endif
    }
}

#if DEBUG
struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(viewModel: .mock)
            .configure()
    }
}
#endif
