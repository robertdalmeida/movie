import SwiftUI

struct DiscoverSection: View {
    let viewModel: ViewModel

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(viewModel.title)
                    .applyAppStyle(.sectionTitle)
                    .padding()
                    .offset(y: 20)
                Spacer()
            }
            switch viewModel.state {
            case .noData:
                ErrorView(message: "Unable to fetch")
            case .showMedia:
                PlainCarousel(viewModel: .init(mediaStore: viewModel.store))
            }
            Spacer()
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
            case showMedia
        }
        
        let context: Context
        let store: MediaCategoryStoreProtocol
        var mediaItems: [Media] = []
        var state: State = .noData
        
        init(context: Context, store: MediaCategoryStoreProtocol) {
            self.context = context
            self.store = store
            
            let initializatinBlock: (ServicedData<PagedResult>) -> State = { servicedData in
                switch servicedData {
                case .uninitalized, .error:
                    return .noData
                case .data:
                    return .showMedia
                }
            }
            
            switch context {
            case .nowPlaying:
                self.state = initializatinBlock(store.movies)
            case .mostPopular:
                self.state = initializatinBlock(store.movies)
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
        DiscoverSection(viewModel: .init(context: .nowPlaying, store: MockStore()))
            .configure()
    }
}
#endif
