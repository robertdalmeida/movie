//
//  TMDbStoreService.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import Foundation
import struct TMDb.Movie
import class TMDb.TMDbAPI
import struct TMDb.ImagesConfiguration

final class ImageResolutionService {
    let tmdb: TMDbAPI
    
    init(tmdb: TMDbAPI) {
        self.tmdb = tmdb
    }
    
    func imageService(url: URL?) async -> URL? {
        guard let configuration = try? await tmdb.configurations.apiConfiguration().images else {
            return nil
        }
        return configuration.posterURL(for: url)
    }
}

final class TMDbStoreService: ObservableObject {
    let tmdb = TMDbAPI(apiKey: "0aff42c3702e51dab885840d01ca77f8")
    lazy var imageResolutionService: ImageResolutionService = { ImageResolutionService(tmdb: tmdb) }()
    
    enum StoreServiceError: Error {
        case somethingFailed(Error?)
    }
    
    enum ServicedData<T> {
        case uninitalized
        case data(T)
        case error(StoreServiceError)
    }
    
    var popularMovies: ServicedData<[Media]> = .uninitalized
    var nowPlayingMovies: ServicedData<[Media]> = .uninitalized

    
    #if DEBUG
    static func mock() -> TMDbStoreService {
        TMDbStoreService(nowPlayingMovies: [.mock, .mock1], popularMovies: [.mock, .mock2])
    }
    
    init(nowPlayingMovies: [Media] = [], popularMovies: [Media] = []) {
        self.popularMovies = .data(popularMovies)
        self.nowPlayingMovies = .data(nowPlayingMovies)
    }
    #endif
    
    func initialize() async -> Result<Void, StoreServiceError> {
        async let popularMovies =  fetchPopularMovies()
        async let nowPlaying = fetchNowPlayingMovies()
        
        switch (await popularMovies, await nowPlaying) {
        case  (.uninitalized, _),
                (_, .uninitalized):
            return .failure(.somethingFailed(nil))
        case (.data(_), .error(let error)),
            (.error(let error), .data(_)),
            (.error(let error), .error(_ )):
            // Made a behavioral decision here, that if we get error in either of the endpoints then we claim an error state. Ofcourse in a real app, we could always recover and show avaialable data if it makes sense.
            return .failure(.somethingFailed(error))
        case (.data(_ ), .data(_)):
            return .success(Void())
        }
    }
    
    func fetchPopularMovies() async -> ServicedData<[Media]> {
        do {
            #warning("Robert: we can implement something to paginate as user scrolls.")
            let movieResult = try await tmdb.discover.movies(sortedBy: .popularity(), withPeople: nil, page: 1)
            let movies = await movieResult.results.asyncMap(transform(movie:))
            popularMovies = .data(movies)
            return .data(movies)
        } catch {
            print("\(#function): \(error)")
            return .error(.somethingFailed(error))
        }
    }
    
    private func transform(movie: Movie) async -> Media {
        let imageURL = await imageResolutionService.imageService(url: movie.posterPath)
        return Media(title: movie.title, image: imageURL, id: movie.id, releaseDate: movie.releaseDate)
    }
    
    func fetchNowPlayingMovies() async -> ServicedData<[Media]>  {
        do {
            #warning("Robert: we can implement something to paginate as user scrolls.")
            let movieResult = try await tmdb.discover.movies(sortedBy: .primaryReleaseDate(descending: true), withPeople: nil, page: 1)
            let movies = await movieResult.results.asyncMap(transform(movie:))
            nowPlayingMovies = .data(movies)
            return .data(movies)
        } catch {
            print("\(#function): \(error)")
            return .error(.somethingFailed(error))
        }
    }
    
    func fetchMorePopularMovies() {
        //ROB: increase the pagination count and request move movies.
    }
    
    func fetchMoreNowPlaying() {
        //ROB: increase the pagination count and request move movies.
    }
    
    func movieDetails() {
//        tmdb.movies.details(forMovie: )
    }
}
