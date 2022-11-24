//
//  TMDbStoreService.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import Foundation
import struct TMDb.Movie
import class TMDb.TMDbAPI

struct TMDbStoreService {
    let tmdb = TMDbAPI(apiKey: "0aff42c3702e51dab885840d01ca77f8")
    
    enum StoreServiceError: Error {
        case somethingFailed(Error)
    }
    
    enum Status<T> {
        case data(T)
        case error(StoreServiceError)
    }
            
    func fetchPopularMovies() async -> Status<[Movie]> {
        do {
            #warning("Robert: we can implement something to paginate as user scrolls.")
            let movieResult = try await tmdb.discover.movies(sortedBy: .popularity(), withPeople: nil, page: 1)
            return .data(movieResult.results)
        } catch {
            print("\(#function): \(error)")
            return .error(.somethingFailed(error))
        }
    }
    
    func fetchNowPlayingMovies() async -> Status<[Movie]>  {
        do {
            #warning("Robert: we can implement something to paginate as user scrolls.")
            let movieResult = try await tmdb.discover.movies(sortedBy: .primaryReleaseDate(descending: true), withPeople: nil, page: 1)
            return .data(movieResult.results)
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

}
