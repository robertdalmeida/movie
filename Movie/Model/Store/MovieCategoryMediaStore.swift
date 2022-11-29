import Foundation

final class MoviesCategoryMediaStore: MediaCategoryStoreProtocol {
    var movies: ServicedData<PagedResult> = .uninitalized
    let service: MediaService
    
    init(movies: ServicedData<PagedResult>, service: MediaService) {
        self.movies = movies
        self.service = service
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
            let (fetched, totalPages, currentPage) = try await service.fetchMedia(page: pageToFetch)
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
            let (fetched, totalPages, currentPage) = try await service.fetchMedia(page: pageToFetch)
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
