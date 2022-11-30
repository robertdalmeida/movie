import Foundation
import struct TMDb.Movie
import class TMDb.TMDbAPI
import struct TMDb.ImagesConfiguration

protocol MediaCategoryStoreProtocol {
    var movies: ServicedData<PagedResult> { get }
    func initialFetch() async -> ServicedData<[Media]>
    func fetchMore() async -> ServicedData<[Media]>
}

enum StoreServiceError: Error {
    case somethingFailed(Error?)
}

enum ServicedData<T> {
    case uninitalized
    case data(T)
    case error(StoreServiceError)
}

/// This type is like a container for the 2 movie stores used in this application the now playing and the popular.
/// This takes the responsibilty to coordinate between them, but the individual stores are more than capable of doing things themselves. 
final class MediaStore: ObservableObject {
    lazy var nowPlayingMediaStore: MediaCategoryStoreProtocol = {
        MoviesCategoryMediaStore(movies: .uninitalized, service: TMDBDiscoverNowPlayingMovieService(configuration: .shared))
    }()
    
    lazy var popularMediaStore: MediaCategoryStoreProtocol = {
        MoviesCategoryMediaStore(movies: .uninitalized, service: TMDBDiscoverPopularMovieService(configuration: .shared))
    }()
        
    // MARK: -  Initialization
    
    func initialize() async -> Result<Void, StoreServiceError> {
        async let popularMovies =  popularMediaStore.initialFetch()
        async let nowPlaying = nowPlayingMediaStore.initialFetch()
        
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
    
    // MARK: -  DEBUG
    #if DEBUG
    static var mock: MediaStore {
        let store = MediaStore()
        Task {
            await store.initialize()
        }
        return store
    }
    #endif
}

