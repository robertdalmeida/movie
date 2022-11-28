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
    
    let tmdb = TMDbAPI(apiKey: "0aff42c3702e51dab885840d01ca77f8")
    lazy var imageResolutionService: ImageResolutionService = { ImageResolutionService(tmdb: tmdb) }()
    
    var popularMovies: ServicedData<[Media]> = .uninitalized
    var nowPlayingMovies: ServicedData<[Media]> = .uninitalized

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
            #warning("Robert: we can implement something to paginate as user scrolls.")
            let movieResult = try await tmdb.discover.movies(sortedBy: .popularity(), withPeople: nil, page: nil)
            let movies = await movieResult.results.asyncMap(transform(movie:))
            popularMovies = .data(movies)
            return .data(movies)
        } catch {
            print("\(#function): \(error)")
            return .error(.somethingFailed(error))
        }
    }
    
    func fetchNowPlayingMovies() async -> ServicedData<[Media]>  {
        do {
            #warning("Robert: we can implement something to paginate as user scrolls.")
            let movieResult = try await tmdb.discover.movies(sortedBy: .primaryReleaseDate(descending: true), withPeople: nil, page: nil)
            let movies = await movieResult.results.asyncMap(transform(movie:))
            nowPlayingMovies = .data(movies)
            return .data(movies)
        } catch {
            print("\(#function): \(error)")
            return .error(.somethingFailed(error))
        }
    }
    
    // MARK: -  Helper
    
    // TODO: Move this to a separate type
    private func transform(movie: Movie) async -> Media {
        let imageURL = await imageResolutionService.cardImageService(url: movie.posterPath)
        let movieDetails = try? await tmdb.movies.details(forMovie: movie.id)
        
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
            print("BOB: \(#function) - movie:\(movie.title) - posterImage:\(imageURL)")
            return .url(imageURL)
        } else {
            return .noPoster
        }
    }
    
    private func thumbnailPosterImage(for movie: Movie) async -> ImageSource {
        if let imageURL = await imageResolutionService.cardImageService(url: movie.posterPath) {
            print("BOB: \(#function) - movie:\(movie.title) - thumbnailImage:\(imageURL)")
            return .url(imageURL)
        } else {
            return .noPoster
        }
    }
}
