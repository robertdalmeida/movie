import Foundation
import Combine

typealias Storable = Decodable & Encodable & Identifiable

struct FileStorageService<T: Storable> {
    private let folderName: String
    
    private var favoriteFolderPath: URL {
        get throws {
            try FileManager.default.url(for: .documentDirectory,
                                         in: .userDomainMask,
                                         appropriateFor: nil,
                                         create: false)
            .appending(path: folderName, directoryHint: .isDirectory)
        }
    }
    
    // MARK: -  init
    init(folderName: String) {
        self.folderName = folderName
    }
    
    // MARK: -  Interfaces
    
    func saveMedia(media: T) async throws -> [T] {
        do {
            try createFavoriteDirectoryIfNecessary()
            let encoded = try JSONEncoder().encode(media)
            if let fileURL = try fileURL(object: media) {
                try encoded.write(to: fileURL, options: .completeFileProtection)
            }
            return try load()
        } catch {
            print("BOB: \(#function) \(error)")
            throw error
        }
        
    }
    
    func fetchStoredMedia() async throws -> [T] {
        try load()
    }
    
    func removeMedia(media: T) async throws -> [T] {
        do {
            if let favoriteURL = try fileURL(object: media) {
                try FileManager.default.removeItem(at: favoriteURL)
            }
            return try load()
        } catch {
            print("BOB: \(#function) \(error)")
            throw error
        }
    }

    // MARK: -  privater helpers
    
    private func fileURL(object: T) throws -> URL? {
        return try favoriteFolderPath.appendingPathComponent("\(object.id)".appending(".json"), isDirectory: false)
    }
    
    private func createFavoriteDirectoryIfNecessary() throws {
        try FileManager.default.createDirectory(at: try favoriteFolderPath, withIntermediateDirectories: true)
    }
    
    private func urlsAtPath() throws -> [URL] {
        try FileManager.default.contentsOfDirectory(at: try favoriteFolderPath, includingPropertiesForKeys: nil)
    }
    
    private func load() throws -> [T] {
        var storedValues: [T] = []
        try createFavoriteDirectoryIfNecessary()
        for url in try urlsAtPath() {
            if let value = try transform(url: url) {
                storedValues.append(value)
            }
        }
        return storedValues
    }
    
    private func transform(url: URL) throws -> T? {
        let data = try Data(contentsOf: url)
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
}

final class FavoritesStore: ObservableObject {
    let storage: FileStorageService<Media> = .init(folderName: "Favorites")
    let imageStore: ImagePersistentStoreService = .init()
    let imageFetchService = ImageFetchingService()
    
    enum Status {
        case inProgress
        case fetched(mediaContents: [Media])
    }
    
    @Published var status: Status = .inProgress
    
    @discardableResult
    func initialize() async -> Result<Void, Error> {
        self.status = .inProgress
        do {
            self.status = .fetched(mediaContents: try await Task {
                try await storage.fetchStoredMedia()
            }.value)
            return .success(Void())
        } catch {
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
        
        self.status = .fetched(mediaContents: try await storage.saveMedia(media: media))
    }
    
    
    
    func removeFavorite(media: Media) async throws {
        self.status = .fetched(mediaContents: try await storage.removeMedia(media: media))
    }
    
    func isMediaAFavorite(media: Media) -> Bool {
        switch status {
        case .inProgress:
            // Good to know place of failure, we could always keep the instance of Task and return its value.
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
