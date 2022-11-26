import Foundation
import Combine

protocol Persistable {
    associatedtype Value: Storable
    func saveMedia(media: Value) async throws -> [Value]
    func fetchStoredMedia() async throws -> [Value]
    func removeMedia(media: Value) async throws -> [Value]
}

struct FileStorageService<T: Storable>: Persistable {
    let folderName: String
    init(folderName: String) {
        self.folderName = folderName
    }
    var favoriteFolderPath: URL {
        get throws {
            try FileManager.default.url(for: .documentDirectory,
                                         in: .userDomainMask,
                                         appropriateFor: nil,
                                         create: false)
            .appending(path: folderName, directoryHint: .isDirectory)
        }
    }
    
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
    func saveMedia(media: T) async throws -> [T] {
        do {
            try createFavoriteDirectoryIfNecessary()
            let encoded = try JSONEncoder().encode(media)
            if let fileURL = try fileURL(object: media) {
                try encoded.write(to: fileURL)
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
}
typealias Storable = Decodable & Encodable & Identifiable
final class FavoritesStore: ObservableObject {
    let storage: FileStorageService<Media> = .init(folderName: "Favorites")
    
    enum Status {
        case inProgress
        case fetched(mediaContents: [Media])
    }
    
    @Published var status: Status = .inProgress
    
    func initialize() {
        self.status = .inProgress
        Task {
            status = .fetched(mediaContents: try await storage.fetchStoredMedia())
        }
    }
    
    #if DEBUG
    static let mock = FavoritesStore()
    #endif
}
