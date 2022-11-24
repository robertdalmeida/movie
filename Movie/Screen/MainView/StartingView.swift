//
//  LandingView.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI

struct StartingView: View {
    @ObservedObject var viewModel = StartingViewModel()
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .dataRecieved:
                TabView {
                    DiscoverView()
                        .tabItem {
                            Label(Localised.discoverTabBarItemTitle,
                                  systemImage: "list.dash")
                        }
                    FavoritesView()
                        .tabItem {
                            Label(Localised.favoriteTabBarItemTitle,
                                  systemImage: "person.circle")
                        }
                }
            case .error:
                ErrorView()
                    .onTapGesture {
                        Task {
                            await viewModel.fetchData()
                        }
                    }
            case .loading:
                ProgressView()
            }
        }
        .task {
            await viewModel.fetchData()
        }
    }
}

struct StartingView_Previews: PreviewProvider {
    static var previews: some View {
        StartingView()
    }
}
