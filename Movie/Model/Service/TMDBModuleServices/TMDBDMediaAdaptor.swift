import Foundation
import struct TMDb.Movie

struct TMDBDMediaAdaptor{
    let imageResolutionService = TMDBImageResolutionService(configuration: .shared)
    let configuration: TMDBConfiguration

    func transform(movie: TMDb.Movie) async throws -> Media {
        let imageURL = await imageResolutionService.cardImageService(url: movie.posterPath)
        var movie = try await configuration.tmdb.movies.details(forMovie: movie.id)
        
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
