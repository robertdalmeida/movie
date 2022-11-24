//
//  LandingViewModel.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import Foundation

@MainActor
final class StartingViewModel: ObservableObject {
    
    enum State {
        case loading
        case error
        case dataRecieved
    }
    
    @Published
    private(set) var state: State = .loading
    
    func fetchData(using storeService: TMDbStoreService) async {
        self.state = .loading
        Task {
            async let popularMovies =  storeService.fetchPopularMovies()
            async let nowPlaying = storeService.fetchNowPlayingMovies()
            switch (await popularMovies, await nowPlaying) {
            case (.data(_), .error(_)), (.error(_), .data(_)), (.error(_ ), .error(_ )):
                // Made a behavioral decision here, that if we get error in either of the endpoints then we claim an error state. Ofcourse in a real app, we could always recover and show avaialable data if it makes sense.
                self.state = .error
            case (.data(_ ), .data(_)):
                self.state = .dataRecieved
            }
        }
    }
}
