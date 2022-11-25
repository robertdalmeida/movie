//
//  DiscoverView.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var appConfiguration: AppConfiguration

    var body: some View {
        VStack {
            Spacer()
            MediaCategoryView(viewModel: .init(context: .mostPopular,
                                               movies: appConfiguration.storeService.popularMovies))
            Spacer()
            MediaCategoryView(viewModel:  .init(context: .nowPlaying,
                                                movies: appConfiguration.storeService.nowPlayingMovies))
            Spacer()
        }
        .background{
            LinearGradient(gradient: Gradient(colors: [.gray, .white, .gray, .white, Color(.white)]), startPoint: .top, endPoint: .bottom)
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
            .configure()
    }
}
