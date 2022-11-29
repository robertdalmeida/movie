import Foundation

extension StartingView {
    @MainActor
    final class ViewModel: ObservableObject {
        enum State {
            case loading
            case error
            case showLocalData
            case dataRecieved
        }
        
        @Published private(set) var state: State = .loading
                
        // MARK:  - Start sequence
        func initiateStartSequence(mediaStore: MediaStore, favoriteStore: FavoritesStore) async {
            self.state = .loading
            Task {
                async let storeServiceStatus = mediaStore.initialize()
                let favoriteStoreInitializationTask = Task {
                    await favoriteStore.initializeAgain()
                }
                await favoriteStoreInitializationTask.value
                
                switch (await storeServiceStatus, favoriteStore.status) {
                case (.failure, .error):
                    self.state = .error
                case (.failure, .fetched):
                    self.state = .showLocalData
                case (.success, .fetched),
                    (.success, .error):
                    self.state = .dataRecieved
                }
            }
        }
    }
}
