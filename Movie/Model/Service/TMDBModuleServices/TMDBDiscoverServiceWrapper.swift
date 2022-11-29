import Foundation
import struct TMDb.Movie
import class TMDb.TMDbAPI

final class TMDBDiscoverServiceWrapper {
    let configuration: TMDBConfiguration
    lazy var adaptor: TMDBDMediaAdaptor = { TMDBDMediaAdaptor(configuration: configuration) }()
    
    private var popularMovies: [TMDb.Movie] = []
    private var nowPlayingMovies: [TMDb.Movie] = []

    init(configuration: TMDBConfiguration) {
        self.configuration = configuration
    }
    
    func fetchPopularMedia(page: Int) async throws -> (media:[Media], totalPages: Int?, currentPage: Int?)  {
        let movieResult = try await configuration.tmdb.discover.movies(sortedBy: .popularity(), withPeople: nil, page: page)
        return (await movieResult.results.asyncMap(adaptor.transform(movie:)), movieResult.totalPages, movieResult.page)
    }
    
    func fetchNowPlayingMedia(page: Int) async throws -> (media:[Media], totalPages: Int?, currentPage: Int?)  {
        let movieResult = try await configuration.tmdb.discover.movies(sortedBy: .primaryReleaseDate(descending: true), withPeople: nil, page: nil)
        return (await movieResult.results.asyncMap(adaptor.transform(movie:)), movieResult.totalPages, movieResult.page)
    }
    
    func fetchMediaDetail(media: Media) async throws -> Media {
        let movie = try await configuration.tmdb.movies.details(forMovie: media.id)
        return await adaptor.transform(movie: movie)
    }
}

struct TMDBDMediaAdaptor{
    let imageResolutionService = TMDBImageResolutionService(configuration: .shared)
    let configuration: TMDBConfiguration

    func transform(movie: TMDb.Movie) async -> Media {
        let imageURL = await imageResolutionService.cardImageService(url: movie.posterPath)
        
        return Media(title: movie.title,
                     image: imageURL,
                     posterImage: await posterImage(for: movie),
                     thumbnailImage: await thumbnailPosterImage(for: movie),
                     id: movie.id,
                     releaseDate: movie.releaseDate,
                     tagLine: movie.tagline,
                     language: movie.originalLanguage,
                     overview: movie.overview,
                     popularity: movie.popularity,
                     voteAverage: movie.voteAverage,
                     adult: movie.adult,
                     genres: genres(for: movie))
    }
    
    private func genres(for movie: Movie) -> [String] {
        movie.genres.map { $0.map(\.name)} ?? []
    }
    
    private func posterImage(for movie: Movie) async -> ImageSource {
        if let imageURL = await imageResolutionService.posterImageService(url: movie.posterPath) {
            return .url(imageURL)
        } else {
            return .noPoster
        }
    }
    
    private func thumbnailPosterImage(for movie: Movie) async -> ImageSource {
        if let imageURL = await imageResolutionService.cardImageService(url: movie.posterPath) {
            return .url(imageURL)
        } else {
            return .noPoster
        }
    }
}
