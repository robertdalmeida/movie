import SwiftUI

struct DiscoverSection: View {
    let viewModel: ViewModel

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.title)
                    .applyAppStyle(.title)
                    .padding()
                Spacer()
            }
            switch viewModel.state {
            case .noData:
                ErrorView(message: "Unable to fetch")
            case .showMedia(let mediaItems):
                HorizontalCarousel(store: .init(mediaItems: mediaItems))
            }
        }
    }
}

extension DiscoverSection {
    struct ViewModel {
        enum Context {
            case mostPopular
            case nowPlaying
            
            var title: String {
                switch self {
                case .mostPopular: return Localised.mostPopularTitle
                case .nowPlaying: return Localised.nowPlayingTitle
                }
            }
        }
        
        enum State {
            case noData
            case showMedia([Media])
        }
        
        let context: Context
        let store: MediaStore
        var mediaItems: [Media] = []
        var state: State = .noData
        
        init(context: Context, store: MediaStore) {
            self.context = context
            self.store = store
            
            let initializatinBlock: (MediaStore.ServicedData<[Media]>) -> State = { servicedData in
                switch servicedData {
                case .uninitalized, .error:
                    return .noData
                case .data(let mediaItems):
                    return .showMedia(mediaItems)
                }
            }
            
            switch context {
            case .nowPlaying:
                self.state = initializatinBlock(store.nowPlayingMovies)
            case .mostPopular:
                self.state = initializatinBlock(store.popularMovies)
            }
        }
        
        var title: String {
            context.title
        }
    }
}

#if DEBUG
struct DiscoverSection_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverSection(viewModel: .init(context: .mostPopular, store: .mock()))
            .configure()
    }
}
#endif
