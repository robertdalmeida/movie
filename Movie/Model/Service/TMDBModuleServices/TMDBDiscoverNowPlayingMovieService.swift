import Foundation

final class TMDBDiscoverNowPlayingMovieService: MediaService {
    let configuration: TMDBConfiguration
    lazy var adaptor: TMDBDMediaAdaptor = { TMDBDMediaAdaptor(configuration: configuration) }()
    
    init(configuration: TMDBConfiguration) {
        self.configuration = configuration
    }
        
    func fetchMedia(page: Int) async throws -> (media:[Media], totalPages: Int?, currentPage: Int?)  {
        let movieResult = try await configuration.tmdb.discover.movies(sortedBy: .primaryReleaseDate(descending: true), withPeople: nil, page: nil)
        return (try await movieResult.results.asyncMap(adaptor.transform(movie:)), movieResult.totalPages, movieResult.page)
    }
    
    
}
