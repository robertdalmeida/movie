//
//  LandingViewModel.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import Foundation

@MainActor
final class StartingViewModel: ObservableObject {
    let storeService = TMDbStoreService()
    
    enum State {
        case loading
        case error
        case dataRecieved
    }
    
    @Published
    private(set) var state: State = .loading
    
    func fetchData() async {
        self.state = .loading
        Task {
            async let popularMovies =  storeService.fetchPopularMovies()
            async let nowPlaying = storeService.fetchNowPlayingMovies()
            switch (await popularMovies, await nowPlaying) {
            case (.data(_), .error(_)), (.error(_), .data(_)), (.error(_ ), .error(_ )):
                self.state = .error
            case (.data(let popularMovies), .data(let nowPlayingMovies)):
                print("BOB: PopularMovies:", popularMovies)
                print("BOB: nowPlayingMovies:", nowPlayingMovies)
//                self.state = .dataRecieved
                self.state = .error

            }
        }
    }
}
