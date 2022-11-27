import Foundation

/// A application type to display any video/movie.
/// External types need to translate to this type to be used in this application.
/// Doing this to avoid adding any direct dependencies with any third party type.
struct Media: Hashable, Codable, Identifiable {
    let title: String
    let image: URL?
    let id: Int
    let releaseDate: Date?
    let tagLine: String?
    let language: String?
    let overview: String?
    let backdropPath: URL?
    let popularity: Double?
    let voteAverage: Double?
    let adult: Bool?
    let genres: [String]?
}

#if DEBUG
extension Media {
    init(title: String,
         image: URL?,
         id: Int,
         releaseDate: Date?) {
        self.init(title: title,
                  image: image,
                  id: id,
                  releaseDate: releaseDate,
                  tagLine: "Some tagline",
                  language: "English",
                  overview: "Movie overview",
                  backdropPath: nil,
                  popularity: 10.4,
                  voteAverage: 9.4,
                  adult: true,
                  genres: [])
    }
    static let mock = Media(title: "Black Adam",
                            image: .mockImageUrlBlackAdam,
                            id: 123,
                            releaseDate: Date(),
                            tagLine: "",
                            language: nil,
                            overview: "Duizenden jaren geleden kreeg een man magische krachten toebedeeld van tovenaar Shazam. Nadat de man zijn gaven voor kwaadaardige doeleinden gebruikte, werd hij eeuwenlang gevangen gezet. Nu staat hij op het punt eindelijk vrij te komen.",
                            backdropPath: .mockBackdropImageURL,
                            popularity: 16093.223,
                            voteAverage: 7.2,
                            adult: false,
                            genres: ["Drama" ,"Action & Adventure"])
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
