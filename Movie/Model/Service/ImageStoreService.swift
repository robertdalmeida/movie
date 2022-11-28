import Foundation
import UIKit

struct ImageContainer {
    typealias UniqueIdentifer = String
    let id: UniqueIdentifer
    let image: UIImage
}

struct FileWritingService {
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
    
    // MARK: -  helper utilities
    
    private func fileURL(id: String) throws -> URL? {
        return try folderPath.appendingPathComponent(id, isDirectory: false)
    }

    private func createDirectoryIfNecessary() throws {
        try FileManager.default.createDirectory(at: try folderPath, withIntermediateDirectories: true)
    }
}

final class ImagePersistentStoreService: ObservableObject {
    let fileWritingService = FileWritingService(folderName: "Images")
    
    enum ImageStoreServiceError: Error {
        case unableToConverImageToPNG
        case underlyingError(Error)
    }
    
    func saveImage(image: UIImage, id: String) -> Result<Void, ImageStoreServiceError> {
        guard let imageData = image.pngData() else {
            return .failure(.unableToConverImageToPNG)
        }
        switch fileWritingService.saveData(data: imageData, id: id) {
        case .failure(let error):
            return .failure(.underlyingError(error))
        case .success():
            return .success(Void())
        }
    }
    
    func retrieveImage(id: String) -> UIImage? {
        guard let imageData = try? fileWritingService.fetchData(id: id).get(),
                let image = UIImage(data: imageData) else {
            return nil
        }
                
        return image
    }
}
