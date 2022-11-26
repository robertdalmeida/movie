//
//  FavoritesView.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI
import Combine

struct FavoritesView: View {
    @EnvironmentObject var appConfiguration: AppConfiguration
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            Text("Favorites")
                .applyAppStyle(.title)
            List {
                ForEach(viewModel.favorites) { item in
                    NavigationLink {
                        MovieDetailView(viewModel: .init(media: item,
                                                         favoriteStoreService: appConfiguration.favoriteService))
                    } label: {
                        FavoriteRow(item: item)
                    }
                }.onDelete(perform: viewModel.deleteFavorite(at:))
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
            favoriteStoreService.initialize()
            favoriteStoreService.$status.receive(on: RunLoop.main)
                .sink { status in
                    switch status {
                    case .fetched(mediaContents: let favorites):
                        self.favorites = favorites
                    case .inProgress:
                        // ROB: Change here to state handling
                        break
                    }
                }.store(in: &anyCancellables)
        }
        
        func deleteFavorite(at offsets: IndexSet) {
            let objectsToRemove = offsets.map { favorites[$0] }
            objectsToRemove.forEach { media in
                Task {
                    try? await favoriteStoreService.storage.removeMedia(media: media)
                }
            }
            favorites.remove(atOffsets: offsets)
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
