import SwiftUI
import Combine

struct FavoritesView: View {
    @EnvironmentObject var appDependencies: AppDependencies
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("Favorites")
                .applyAppStyle(.title)
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
}

extension FavoritesView {
    final class ViewModel: ObservableObject {
        @Published var favorites: [Media] = []
        let favoriteStoreService: FavoritesStore
        private var anyCancellables: [AnyCancellable] = []
        
        init(favoriteStoreService: FavoritesStore) {
            self.favoriteStoreService = favoriteStoreService

            favoriteStoreService.$status.receive(on: RunLoop.main)
                .sink { status in
                    print("BOB: \(#function)")
                    switch status {
                    case .fetched(mediaContents: let favorites):
                        self.favorites = favorites
                    case .notInitialized, .error:
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

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(viewModel: .mock)
            .configure()
    }
}
