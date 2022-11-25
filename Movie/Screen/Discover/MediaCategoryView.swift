//
//  MediaCategoryView.swift
//  Movie
//
//  Created by Robert D'Almeida on 25/11/2022.
//

import SwiftUI

struct MediaCategoryView: View {
    let viewModel: MediaCategoryViewModel

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.title)
                    .applyAppStyle(.title)
                    .padding()
                Spacer()
            }
            HorizontalCarousel(store: .init(movies: viewModel.movies))
        }
    }
}

extension MediaCategoryView {
    struct MediaCategoryViewModel {
        enum Context {
            case mostPopular
            case nowPlaying
            
            var title: String {
                switch self {
                case .mostPopular: return "Most popular"
                case .nowPlaying: return "Now playing"
                }
            }
        }
        
        let context: Context
        let movies: [Media]
        
        var title: String {
            context.title
        }
    }
}

struct MediaCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        MediaCategoryView(viewModel: .init(context: .nowPlaying,
                                           movies: [.mock, .mock1, .mock2]))
            .configure()
    }
}
