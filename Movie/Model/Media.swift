import Foundation

/// A application type to display any video/movie.
/// External types need to translate to this type to be used in this application.
/// Doing this to avoid adding any direct dependencies with any third party type.
struct Media {
    let title: String
    let image: URL?
    let id: Int
}

#if DEBUG
extension Media {
    static let mock = Media(title: "Black Adam",
                            image: .mockImageUrlBlackAdam,
                            id: 123)
    static let mock1 = Media(title: "R.I.P.D. 2: Rise of the Damned",
                             image: .mockImageUrlRiseOfTheDamned,
                             id: 1234)
    static let mock2 = Media(title: "Black Panther: Wakanda Forever",
                             image: .mockImageUrlBlackPanther,
                             id: 12345)
}
#endif
