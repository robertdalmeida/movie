import Foundation
import Combine

final class FavoritesStore: ObservableObject {
    let storage: FileStorageService = .init(folderName: "Favorites")
    let imageStore: ImagePersistentStoreService = .init()
    let imageFetchService = ImageFetchingService()
    
    enum Status {
        case notInitialized
        case fetched(mediaContents: [Media])
        case error
    }
    
    @Published var status: Status = .notInitialized
    
    @discardableResult
    func initialize() -> Result<Void, Error> {
        self.status = .notInitialized
        do {
            let mediaContents = try storage.ids().map{
                let data = try storage.fetchData(id: $0).get()
                return try JSONDecoder().decode(Media.self, from: data)
            }
            self.status = .fetched(mediaContents: mediaContents)
            return .success(Void())
        } catch {
            self.status = .error
            return .failure(error)
        }
    }
    
    func saveFavorite(media: Media) async throws {
        switch media.posterImage {
        case .url(let url):
            let identifier = "\(media.id)_poster"
            let image = try await imageFetchService.fetch(url)
            try imageStore.saveImage(image: image, id: identifier).get()
            media.posterImage = .localFile(fileIdentifier: identifier)
        case .noPoster, .localFile:
            break
        }
        
        switch media.thumbnailImage {
        case .url(let url):
            let identifier = "\(media.id)_thumbnail"
            let image = try await imageFetchService.fetch(url)
            try imageStore.saveImage(image: image, id: identifier).get()
            media.thumbnailImage = .localFile(fileIdentifier: identifier)
        case .noPoster, .localFile:
            break
        }
        
        let data = try encodeMedia(media: media)
        try storage.saveData(data: data, id: "\(media.id)").get()
        initialize()
    }
    
    func encodeMedia(media: Media) throws -> Data {
         try JSONEncoder().encode(media)
    }
    
    func removeFavorite(media: Media) throws {
        try storage.deleteData(id: "\(media.id)").get()
        initialize()
    }
    
    func isMediaAFavorite(media: Media) -> Bool {
        switch status {
        case .notInitialized, .error:
            return false
        case .fetched(mediaContents: let mediaContents):
            return mediaContents.contains { savedMedia in
                savedMedia.id == media.id
            }
        }
    }
    
    #if DEBUG
    static let mock = FavoritesStore()
    #endif
}
