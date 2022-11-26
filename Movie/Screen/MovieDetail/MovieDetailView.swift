//
//  MovieDetailView.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject var favoriteStoreService: FavoritesStore
    let viewModel: ViewModel
    
    @State var offline = false
    var body: some View {
        VStack{
            if offline {
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
                Button("Favorite") {
                    viewModel.favoriteButtonTapped()
                }
            }
            .padding()
        }.navigationTitle(viewModel.title)
    }
}

extension MovieDetailView {
    struct ViewModel {
        
        let media: Media
        let favoriteStoreService: FavoritesStore
        
        var title: String {
            media.title
        }
        var releaseDate: Date? {
            media.releaseDate
        }
        var image: URL? {
            media.image
        }
        
        func favoriteButtonTapped() {
            Task {
                do {
                    try await favoriteStoreService.storage.saveMedia(media: media)
                } catch {
                    
                }
            }
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(viewModel: .init(media: .mock,
                                         favoriteStoreService: .mock))
            .configure()
    }
}
