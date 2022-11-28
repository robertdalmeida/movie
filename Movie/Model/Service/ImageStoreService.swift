import Foundation
import UIKit

struct ImageContainer {
    typealias UniqueIdentifer = String
    let id: UniqueIdentifer
    let image: UIImage
}


final class ImagePersistentStoreService: ObservableObject {
    let fileWritingService = FileStorageService(folderName: "Images")
    
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
