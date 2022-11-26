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
    @EnvironmentObject var mediaNavigationCoordinator: MediaNavigationCoordinator

    var body: some View {
        List(viewModel.favorites) { item in
            NavigationLink {
                MovieDetailView(viewModel: .init(media: item,
                                                 favoriteStoreService: appConfiguration.favoriteService))
            } label: {
                HStack{
                    Text(item.title)
                    if let date = item.releaseDate {
                        Text(date, style: .date)
                    }
                }
            }
        }
    }
}

extension FavoritesView {
    final class ViewModel: ObservableObject {
        @Published var favorites: [Media] = []
        
        var anyCancellables: [AnyCancellable] = []
        init(favoriteStoreService: FavoritesStore) {
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
