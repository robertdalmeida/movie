import Foundation
import struct TMDb.Movie
import class TMDb.TMDbAPI
import struct TMDb.ImagesConfiguration

protocol MediaStoreProtocol {
    var movies: ServicedData<PagedResult> { get }
    func initialFetch() async -> ServicedData<[Media]>
    func fetchMore() async -> ServicedData<[Media]>
}

final class NowPlayingMediaStore: MediaStoreProtocol {
    var movies: ServicedData<PagedResult> = .uninitalized
    let discoverServiceWrapper: TMDBDiscoverServiceWrapper
    
    init(movies: ServicedData<PagedResult>, discoverServiceWrapper: TMDBDiscoverServiceWrapper) {
        self.movies = movies
        self.discoverServiceWrapper = discoverServiceWrapper
    }
    
    func initialFetch() async -> ServicedData<[Media]> {
        var pageToFetch = 1
        var pagedResult: PagedResult
        switch movies {
        case .uninitalized, .error:
            pageToFetch = 1
            pagedResult = .init()
            
        case .data:
            return await fetchMore()
        }
        
        do {
            let (fetched, totalPages, currentPage) = try await discoverServiceWrapper.fetchNowPlayingMedia(page: pageToFetch)
            pagedResult.movies = pagedResult.movies + fetched
            pagedResult.totalPages = totalPages ?? 0
            pagedResult.currentPage = currentPage ?? 0
            movies = .data(pagedResult)
            return .data(fetched)
        } catch {
            movies = .error(.somethingFailed(error))
            return .error(.somethingFailed(error))
        }
    }
    
    func fetchMore() async -> ServicedData<[Media]> {
        var pageToFetch = 1
        var pagedResult: PagedResult

        switch movies {
        case .uninitalized, .error:
                return await initialFetch()
        case .data(let currentlyPaged):
            if currentlyPaged.currentPage < currentlyPaged.totalPages {
                pageToFetch = currentlyPaged.currentPage + 1
            }
            pagedResult = currentlyPaged
        }
        
        do {
            let (fetched, totalPages, currentPage) = try await discoverServiceWrapper.fetchNowPlayingMedia(page: pageToFetch)
            pagedResult.movies = pagedResult.movies + filterDuplicates(fetched, from: pagedResult.movies)
            pagedResult.totalPages = totalPages ?? 0
            pagedResult.currentPage = currentPage ?? 0
            movies = .data(pagedResult)
            return .data(fetched)
        } catch {
            return .error(.somethingFailed(error))
        }
    }
    
    func filterDuplicates(_ media: [Media], from superSetMedia: [Media]) -> [Media] {
        media.filter {
            superSetMedia.contains($0)
        }
    }

}

final class PopularMediaStore: MediaStoreProtocol {
    var movies: ServicedData<PagedResult> = .uninitalized
    let discoverServiceWrapper: TMDBDiscoverServiceWrapper
    
    init(movies: ServicedData<PagedResult>, discoverServiceWrapper: TMDBDiscoverServiceWrapper) {
        self.movies = movies
        self.discoverServiceWrapper = discoverServiceWrapper
    }
    
    func initialFetch() async -> ServicedData<[Media]> {
        var pageToFetch = 1
        var pagedResult: PagedResult
        switch movies {
        case .uninitalized, .error:
            pageToFetch = 1
            pagedResult = .init()
            
        case .data:
            return await fetchMore()
        }
        
        do {
            let (fetched, totalPages, currentPage) = try await discoverServiceWrapper.fetchPopularMedia(page: pageToFetch)
            pagedResult.movies = fetched
            pagedResult.totalPages = totalPages ?? 0
            pagedResult.currentPage = currentPage ?? 0
            movies = .data(pagedResult)
            return .data(fetched)
        } catch {
            movies = .error(.somethingFailed(error))
            return .error(.somethingFailed(error))
        }
    }
    
    func fetchMore() async -> ServicedData<[Media]> {
        var pageToFetch = 1
        var pagedResult: PagedResult

        switch movies {
        case .uninitalized, .error:
                return await initialFetch()
        case .data(let currentlyPaged):
            if currentlyPaged.currentPage < currentlyPaged.totalPages {
                pageToFetch = currentlyPaged.currentPage + 1
            }
            pagedResult = currentlyPaged
        }
        
        do {
            let (fetched, totalPages, currentPage) = try await discoverServiceWrapper.fetchPopularMedia(page: pageToFetch)
            pagedResult.movies = pagedResult.movies + filterDuplicates(fetched, from: pagedResult.movies)
            pagedResult.totalPages = totalPages ?? 0
            pagedResult.currentPage = currentPage ?? 0
            movies = .data(pagedResult)
            return .data(fetched)
        } catch {
            return .error(.somethingFailed(error))
        }
    }
    
    func filterDuplicates(_ media: [Media], from superSetMedia: [Media]) -> [Media] {
        media.filter {
            superSetMedia.contains($0)
        }
    }
}


enum StoreServiceError: Error {
    case somethingFailed(Error?)
}

enum ServicedData<T> {
    case uninitalized
    case data(T)
    case error(StoreServiceError)
}

final class PagedResult {
    var currentPage = 1
    var totalPages: Int = 1
    var movies: [Media] = []
    init(currentPage: Int = 1, totalPages: Int = 1, movies: [Media] = []) {
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.movies = self.movies + movies
    }
}

final class MediaStore {
    let discoverServiceWrapper: TMDBDiscoverServiceWrapper = .init(configuration: .shared)
    lazy var nowPlayingMediaStore: NowPlayingMediaStore = {
        NowPlayingMediaStore(movies: .uninitalized, discoverServiceWrapper: discoverServiceWrapper)
    }()
    
    lazy var popularMediaStore: PopularMediaStore = {
        PopularMediaStore(movies: .uninitalized, discoverServiceWrapper: discoverServiceWrapper)
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
    
    // MARK: -  Interfaces
    
    func fetchMediaDetail(media: Media) async throws -> Media {
        try await discoverServiceWrapper.fetchMediaDetail(media: media)
    }
    
    // MARK: -  DEBUG
    #if DEBUG
    static let mock = MediaStore()
    #endif
}

