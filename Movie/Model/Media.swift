import Foundation

/// A application type to display any video/movie.
/// External types need to translate to this type to be used in this application.
/// Doing this to avoid adding any direct dependencies with any third party type.
final class Media: Hashable, Codable, Identifiable {
    let title: String
    let image: URL?
    var posterImage: ImageSource
    var thumbnailImage: ImageSource
    let id: Int
    let releaseDate: Date?
    let tagLine: String?
    let language: String?
    let overview: String?
    let popularity: Double?
    let voteAverage: Double? // User Score
    let adult: Bool?
    let genres: [String]?
    
    init(title: String, image: URL?, posterImage: ImageSource, thumbnailImage: ImageSource, id: Int, releaseDate: Date?, tagLine: String?, language: String?, overview: String?, popularity: Double?, voteAverage: Double?, adult: Bool?, genres: [String]?) {
        self.title = title
        self.image = image
        self.posterImage = posterImage
        self.thumbnailImage = thumbnailImage
        self.id = id
        self.releaseDate = releaseDate
        self.tagLine = tagLine
        self.language = language
        self.overview = overview
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.adult = adult
        self.genres = genres
    }
    
    static func == (lhs: Media, rhs: Media) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}

enum ImageSource : Codable, Hashable, Equatable {
    case noPoster
    case url(URL)
    case localFile(fileIdentifier: String)
}

#if DEBUG
extension Media {
    convenience init(title: String,
         image: URL?,
         id: Int,
         releaseDate: Date?) {
        self.init(title: title,
                  image: image,
                  posterImage:  URL.mockBackdropImageURL != nil ? .url(URL.mockBackdropImageURL!) : .noPoster,
                  thumbnailImage: URL.mockBackdropImageURL != nil ? .url(URL.mockBackdropImageURL!) : .noPoster,
                  id: id,
                  releaseDate: releaseDate,
                  tagLine: "Some tagline",
                  language: "English",
                  overview: "Movie overview",
                  popularity: 10.4,
                  voteAverage: 9.4,
                  adult: true,
                  genres: [])
    }
    static let mock = Media(title: "Black Adam",
                            image: .mockImageUrlBlackAdam,
                            posterImage:  URL.mockBackdropImageURL != nil ? .url(URL.mockBackdropImageURL!) :.noPoster,
                            thumbnailImage: URL.mockBackdropImageURL != nil ? .url(URL.mockBackdropImageURL!) : .noPoster,
                            id: 123,
                            releaseDate: Date(),
                            tagLine: "",
                            language: nil,
                            overview: "Duizenden jaren geleden kreeg een man magische krachten toebedeeld van tovenaar Shazam. Nadat de man zijn gaven voor kwaadaardige doeleinden gebruikte, werd hij eeuwenlang gevangen gezet. Nu staat hij op het punt eindelijk vrij te komen.",
                            popularity: 16093.223,
                            voteAverage: 7.2,
                            adult: false,
                            genres: ["Drama" ,"Action & Adventure", "Drama" ,"Action & Adventure", "Romance"])
    static let mock1 = Media(title: "R.I.P.D. 2: Rise of the Damned",
                             image: .mockImageUrlRiseOfTheDamned,
                             id: 1234,
                             releaseDate: Date())
    static let mock2 = Media(title: "Black Panther: Wakanda Forever",
                             image: .mockImageUrlBlackPanther,
                             id: 12345,
                             releaseDate: Date())
    static let mock3 = Media(title: "Emily the Criminal",
                             image: .mockImageUrlEmilyTheCriminal,
                             id: 12345,
                             releaseDate: Date())

    static let mock4 = Media(title: "MexZombies",
                             image: .mockImageUrlMexZombies,
                             id: 12345,
                             releaseDate: Date())

    static let mock5 = Media(title: "Margaux",
                             image: .mockImageUrlMargaux,
                             id: 12345,
                             releaseDate: Date())

    static let mock6 = Media(title: "The Lair",
                             image: .mockImageUrlTheLair,
                             id: 12345,
                             releaseDate: Date())
}
#endif
