import Foundation
import struct TMDb.Movie
import class TMDb.TMDbAPI

final class TMDBDiscoverMovieDetailService {
    let configuration: TMDBConfiguration
    lazy var adaptor: TMDBDMediaAdaptor = { TMDBDMediaAdaptor(configuration: configuration) }()
    
    init(configuration: TMDBConfiguration) {
        self.configuration = configuration
    }
    
    func fetchMediaDetail(media: Media) async throws -> Media {
        let movie = try await configuration.tmdb.movies.details(forMovie: media.id)
        return try await adaptor.transform(movie: movie)
    }
}
