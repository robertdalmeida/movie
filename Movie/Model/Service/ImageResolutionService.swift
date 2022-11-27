import Foundation
import class TMDb.TMDbAPI
import struct TMDb.ImagesConfiguration

final class ImageResolutionService {
    let tmdb: TMDbAPI
    
    init(tmdb: TMDbAPI) {
        self.tmdb = tmdb
    }
    
    func imageService(url: URL?) async -> URL? {
        guard let configuration = try? await tmdb.configurations.apiConfiguration().images else {
            return nil
        }
        return configuration.posterURL(for: url)
    }
    
    func backdropService(url: URL?) async -> URL? {
        guard let configuration = try? await tmdb.configurations.apiConfiguration().images else {
            return nil
        }
        return configuration.backdropURL(for: url)

    }
}
