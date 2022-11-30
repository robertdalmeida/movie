import Foundation
import UIKit

/// Fetches an image given a url.
actor ImageFetchingService {
    private var images: [URL: ImageRequestStatus] = [:]

    lazy var urlSession: URLSession = {
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 3.0
        session.configuration.timeoutIntervalForResource = 3.0
        return session
    }()
    
    private enum ImageRequestStatus {
        case inProgress(Task<UIImage, Error>)
    }

    enum ImageFetchingServiceError: Error {
        case unableToFetchImageDataFromTheURL
    }
        
    public func fetch(_ url: URL) async throws -> UIImage {
        if let status = images[url] {
            switch status {
            case .inProgress(let task):
                return try await task.value
            }
        }

        let task = Task {
            let (imageData, _) = try await urlSession.data(for: URLRequest(url: url))
            if let image = UIImage(data: imageData) {
                return image
            } else {
                throw ImageFetchingServiceError.unableToFetchImageDataFromTheURL
            }
        }

        images[url] = .inProgress(task)
        let image = try await task.value
        images[url] = nil

        return image
    }
}
