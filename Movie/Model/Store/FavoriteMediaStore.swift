import Foundation
@MainActor
final class FavoritesStore: ObservableObject {
    let storage: FileStorageService = .init(folderName: "Favorites")
    let imageStore: ImageStore = .init()
    
    enum Status {
        case fetched(mediaContents: [Media])
        case error
        
    }
    
    @Published var status: Status = .error
        
    func initializeAgain() async {
        do {
            let mediaContents = try storage.ids().map{
                let data = try storage.fetchData(id: $0).get()
                return try JSONDecoder().decode(Media.self, from: data)
            }
            await MainActor.run(body: {
                self.status = .fetched(mediaContents: mediaContents)
            })

        }catch{
            await MainActor.run(body: {
                self.status = .error
            })
        }
    }

    
    func saveFavorite(media: Media) async throws {
        let task = Task {
            async let posterImageSource = retrievePosterImage(media: media)
            async let thumbnailImageSource = retrieveThumbnailImage(media: media)
            return (posterImage: try await posterImageSource, thumbnailImage: try await thumbnailImageSource)
        }
        
        media.thumbnailImage = try await task.value.thumbnailImage
        media.posterImage = try await task.value.posterImage
        
        let data = try encodeMedia(media)
        try storage.saveData(data: data, id: "\(media.id)").get()
        await initializeAgain()
    }
        
    func removeFavorite(media: Media) async throws {
        try storage.deleteData(id: "\(media.id)").get()
        await initializeAgain()
    }
    
    func isMediaAFavorite(media: Media) -> Bool {
        switch status {
        case .error:
            return false
        case .fetched(mediaContents: let mediaContents):
            return mediaContents.contains { savedMedia in
                savedMedia.id == media.id
            }
        }
    }
    
    // MARK: -  helper
    private func encodeMedia(_ media: Media) throws -> Data {
         try JSONEncoder().encode(media)
    }
    
    private func retrievePosterImage(media: Media) async throws -> ImageSource {
        switch media.posterImage {
        case .url(let url):
            let identifier = "\(media.id)_poster"
            try await imageStore.retriveImage(url: url, identifier: identifier)
            return .localFile(fileIdentifier: identifier)
        case .noPoster, .localFile:
            return media.thumbnailImage
        }
    }
    
    private func retrieveThumbnailImage(media: Media) async throws -> ImageSource {
        switch media.thumbnailImage {
        case .url(let url):
            let identifier = "\(media.id)_thumbnail"
            try await imageStore.retriveImage(url: url, identifier: identifier)
            return .localFile(fileIdentifier: identifier)
        case .noPoster, .localFile:
            return media.thumbnailImage
        }
    }
    
    #if DEBUG
    static let mock = FavoritesStore()
    #endif
}
