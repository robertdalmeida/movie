import Foundation
import struct TMDb.Movie
import class TMDb.TMDbAPI
import struct TMDb.ImagesConfiguration

final class MediaStore {
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
    
    let discoverServiceWrapper: TMDBDiscoverServiceWrapper = .init(configuration: .shared)
    // MARK: -  debug
    
    #if DEBUG
    static func mock() -> Self {
        .init(nowPlayingMovies: [.mock, .mock1], popularMovies: [.mock, .mock2])
    }
    
    init(nowPlayingMovies: [Media] = [], popularMovies: [Media] = []) {
        self.popularMovies = .data(popularMovies)
        self.nowPlayingMovies = .data(nowPlayingMovies)
    }
    #endif
    
    // MARK: -  Initialization
    
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
    
    // MARK: -  Interfaces
    func fetchPopularMovies() async -> ServicedData<[Media]> {
        do {
            let fetched = try await discoverServiceWrapper.fetchPopularMedia()
            popularMovies = .data(fetched)
            return popularMovies
        } catch {
            return .error(.somethingFailed(error))
        }
    }
    
    func fetchNowPlayingMovies() async -> ServicedData<[Media]>  {
        do {
            let fetched = try await discoverServiceWrapper.fetchNowPlayingMedia()
            nowPlayingMovies = .data(fetched)
            return nowPlayingMovies
        } catch {
            return .error(.somethingFailed(error))
        }
    }
}
