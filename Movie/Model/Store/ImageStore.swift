import Foundation
import UIKit

/// <#Description#>
final class ImageStore: ObservableObject {
    let fileStorageService = FileStorageService(folderName: "Images")
    let imageFetchService = ImageFetchingService()

    enum ImageStoreServiceError: Error {
        case unableToConverImageToPNG
        case underlyingError(Error)
    }
    
    func retriveImage(url: URL, identifier: String) async throws {
        let image = try await imageFetchService.fetch(url)
        try saveImage(image: image, id: identifier).get()
    }
    
    func saveImage(image: UIImage, id: String) -> Result<Void, ImageStoreServiceError> {
        guard let imageData = image.pngData() else {
            return .failure(.unableToConverImageToPNG)
        }
        switch fileStorageService.saveData(data: imageData, id: id) {
        case .failure(let error):
            return .failure(.underlyingError(error))
        case .success():
            return .success(Void())
        }
    }
    
    func retrieveImage(id: String) -> UIImage? {
        guard let imageData = try? fileStorageService.fetchData(id: id).get(),
                let image = UIImage(data: imageData) else {
            return nil
        }
                
        return image
    }
}
