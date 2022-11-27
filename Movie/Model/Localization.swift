import Foundation

@propertyWrapper
/// This property wrapper assists in translating keys in the strings file.
/// You can provide a default value if in case it doesn't exist in the strings file, every key has a default value define in `Localizable.LocalizableKey` - you have an option to override this value.
struct Localizable {
    let defaultValue: String
    let key: LocalizableKey
    
    var wrappedValue: String {
        get {
            let translatedValue = NSLocalizedString(key.rawValue, comment: "")
            if translatedValue == key.rawValue {
                return defaultValue
            } else {
                return translatedValue
            }
        }
    }
    
    init(key: LocalizableKey) {
        self.defaultValue = key.defaultValue
        self.key = key
    }
    
    init(defaultValue: String, key: LocalizableKey) {
        self.defaultValue = defaultValue
        self.key = key
    }
}

extension Localizable {
    enum LocalizableKey: String {
        case welcomeScreenTitle = "app.title"
        
        case nowPlayingTitle = "nowPlaying.title"
        case mostPopularTitle = "mostPopular.title"

        case favoriteTabBarItemTitle = "favoriteTabBarItem.title"
        case discoverTabBarItemTitle = "discoverTabBarItemTitle.title"

        var defaultValue: String {
            switch self {
            case .welcomeScreenTitle: return "Hello"
            
            case .nowPlayingTitle: return "Now Playing"
            case .mostPopularTitle: return "Most Popular"

            case .favoriteTabBarItemTitle: return "Favorites"
            case .discoverTabBarItemTitle: return "Discover"
            }
        }
    }
}

enum Localised {
    @Localizable(key: .welcomeScreenTitle) static var welcomeScreenTitle
    @Localizable(key: .favoriteTabBarItemTitle) static var favoriteTabBarItemTitle
    @Localizable(key: .discoverTabBarItemTitle) static var discoverTabBarItemTitle

    @Localizable(key: .nowPlayingTitle) static var nowPlayingTitle
    @Localizable(key: .mostPopularTitle) static var mostPopularTitle


}
