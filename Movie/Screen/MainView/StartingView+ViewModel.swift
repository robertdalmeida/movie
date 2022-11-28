import Foundation

extension StartingView {
    @MainActor
    final class ViewModel: ObservableObject {
        let appDependencies: AppDependencies
        
        enum State {
            case loading
            case error
            case showLocalData
            case dataRecieved
        }
        
        @Published private(set) var state: State = .loading
        
        // MARK: - Init
        init(appDependencies: AppDependencies) {
            self.appDependencies = appDependencies
        }
        
        // MARK:  - Start sequence
        func initiateStartSequence() async {
            self.state = .loading
            Task {
                async let storeServiceStatus = appDependencies.mediaStore.initialize()
                async let favoriteInitializationStatus = appDependencies.favoriteStore.initialize()

                switch (await storeServiceStatus, await favoriteInitializationStatus) {
                case (.failure, .failure):
                    self.state = .error
                case (.failure, .success):
                    self.state = .showLocalData
                case (.success, .success),
                        (.success, .failure):
                    self.state = .dataRecieved
                }
            }
        }
    }
}
