import Foundation

/// Use this type to store some data(`Data`) as files in a folder.
/// In this application this is used to store both images and the favorites.
struct FileStorageService {
    enum FileServiceError: Error {
        case fileNotFound
        case otherError(Error)
    }

    private let folderName: String
    
    private var folderPath: URL {
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

    func saveData(data: Data, id: String) -> Result<Void, FileServiceError> {
        do {
            try createDirectoryIfNecessary()
            if let fileURL = try fileURL(id: id) {
                try data.write(to: fileURL, options: .completeFileProtection)
            }
            return .success(Void())
        } catch {
            return .failure(.otherError(error))
        }
    }
    
    func fetchData(id: String) -> Result<Data, FileServiceError> {
        do {
            if let fileURL = try fileURL(id: id) {
                let data = try Data(contentsOf: fileURL)
                return .success(data)
            } else {
                return .failure(.fileNotFound)
            }
        } catch {
            return .failure(.otherError(error))
        }
    }
    
    func ids() throws -> [String] {
        let urls = try FileManager.default.contentsOfDirectory(at: try folderPath,
                                                               includingPropertiesForKeys: nil)
        return urls.map { $0.lastPathComponent }
    }
    
    func deleteData(id: String) -> Result<Void, FileServiceError> {
        do {
            if let fileURL = try fileURL(id: id) {
                try FileManager.default.removeItem(at: fileURL)
                return .success(Void())
            }
            return .failure(.fileNotFound)
        } catch {
            return .failure(.otherError(error))
        }
    }
    
    
    // MARK: -  helper utilities
    
    private func fileURL(id: String) throws -> URL? {
        return try folderPath.appendingPathComponent(id, isDirectory: false)
    }

    private func createDirectoryIfNecessary() throws {
        try FileManager.default.createDirectory(at: try folderPath, withIntermediateDirectories: true)
    }
}
