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
        case somethingFailed(Error)
    }
    
    enum Status<T> {
        case data(T)
        case error(StoreServiceError)
    }
    
    var popularMovies: [Media]
    var nowPlayingMovies: [Media]

    init(nowPlayingMovies: [Media] = [], popularMovies: [Media] = []) {
        self.popularMovies = popularMovies
        self.nowPlayingMovies = nowPlayingMovies
    }
    
    #if DEBUG
    static func mock() -> TMDbStoreService {
        TMDbStoreService(nowPlayingMovies: [.mock, .mock1], popularMovies: [.mock, .mock2])
    }
    #endif
    
    func fetchPopularMovies() async -> Status<[Media]> {
        do {
            #warning("Robert: we can implement something to paginate as user scrolls.")
            let movieResult = try await tmdb.discover.movies(sortedBy: .popularity(), withPeople: nil, page: 1)
            let movies = await movieResult.results.asyncMap(transform(movie:))
            popularMovies = movies
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
    
    func fetchNowPlayingMovies() async -> Status<[Media]>  {
        do {
            #warning("Robert: we can implement something to paginate as user scrolls.")
            let movieResult = try await tmdb.discover.movies(sortedBy: .primaryReleaseDate(descending: true), withPeople: nil, page: 1)
            let movies = await movieResult.results.asyncMap(transform(movie:))
            nowPlayingMovies = movies
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
