import Foundation
import class TMDb.TMDbAPI
import struct TMDb.ImagesConfiguration

final class TMDBImageResolutionService {
    let configuration: TMDBConfiguration
    init(configuration: TMDBConfiguration) {
        self.configuration = configuration
    }
    
    func cardImageService(url: URL?) async -> URL? {
        guard let configuration = try? await configuration.tmdb.configurations.apiConfiguration().images else {
            return nil
        }
        return configuration.posterURL(for: url, idealWidth: 200)
    }
    
    func posterImageService(url: URL?) async -> URL? {
        guard let configuration = try? await configuration.tmdb.configurations.apiConfiguration().images else {
            return nil
        }
        return configuration.posterURL(for: url)
    }
}
