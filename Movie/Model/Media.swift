import Foundation

/// A application type to display any video/movie.
/// External types need to translate to this type to be used in this application.
/// Doing this to avoid adding any direct dependencies with any third party type.
struct Media {
    let title: String
    let image: URL?
    let id: Int
    let releaseDate: Date?
}

#if DEBUG
extension Media {
    static let mock = Media(title: "Black Adam",
                            image: .mockImageUrlBlackAdam,
                            id: 123,
                            releaseDate: Date())
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
