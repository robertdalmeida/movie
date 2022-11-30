import Foundation
import class TMDb.TMDbAPI

final class TMDBConfiguration {
    static let shared = TMDBConfiguration()
    let tmdb = TMDbAPI(apiKey: "0aff42c3702e51dab885840d01ca77f8") // Inactive key - use your own key instead. 
    private init() {
        
    }
}
