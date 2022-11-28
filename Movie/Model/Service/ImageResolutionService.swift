import Foundation
import class TMDb.TMDbAPI
import struct TMDb.ImagesConfiguration

final class ImageResolutionService {
    let tmdb: TMDbAPI
    
    init(tmdb: TMDbAPI) {
        self.tmdb = tmdb
    }
    
    func cardImageService(url: URL?) async -> URL? {
        guard let configuration = try? await tmdb.configurations.apiConfiguration().images else {
            return nil
        }
        return configuration.posterURL(for: url, idealWidth: 200)
    }
    
    func posterImageService(url: URL?) async -> URL? {
        guard let configuration = try? await tmdb.configurations.apiConfiguration().images else {
            return nil
        }
        return configuration.posterURL(for: url, idealWidth: 200)
    }
}
