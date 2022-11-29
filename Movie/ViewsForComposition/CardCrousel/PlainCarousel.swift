import SwiftUI

extension PlainCarousel {
    @MainActor
    final class ViewModel: ObservableObject {
        enum State {
            case error
            case loading
            case loaded
        }
        @Published var items: [CarouselCard.Item]
        let mediaStore: MediaStoreProtocol
        var state: State
        
        init(mediaStore: MediaStoreProtocol) {
            items = []
            self.mediaStore = mediaStore
            state = .loading
            
            switch mediaStore.movies {
            case .uninitalized, .error:
                self.state = .error
            case .data(let pagedResult):
                for i in 0..<pagedResult.movies.count {
                    let new = CarouselCard.Item(order: i,
                                                mediaReference: pagedResult.movies[i])
                    items.append(new)
                    
                }
                self.state = .loaded
            }
        }
        
        func appendMoreMovies(_ movies: [Media]) {
            var theLastValidOrder = self.items.last?.id ?? 0
            theLastValidOrder += 1
            for i in 0..<movies.count {
                let new = CarouselCard.Item(order: theLastValidOrder,
                                            mediaReference: movies[i])
                items.append(new)
                theLastValidOrder += 1
            }
        }
        
        func onAppear(item visibleItem: CarouselCard.Item) {
            let currentCacheCount = items.count
            guard let index = items.firstIndex(where: { item in
                item.id == visibleItem.id
            }) else { return }
            if (currentCacheCount - index) < 5 { // if it is the last few cards
                fetchNextPage()
            }
        }
        
        func fetchNextPage() {
            switch state {
            case .error, .loaded:
                self.state = .loading
                Task {
                    switch (await mediaStore.fetchMore()) {
                    case .data(let movies):
                        appendMoreMovies(movies)
                    case .error, .uninitalized:
                        break //Robert: Maybe some error handling here would be good - but not planning to do for this excersice.
                    }
                    self.state = .loaded
                }
            case .loading:
                return
            }
        }
    }
}

struct PlainCarousel: View {
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var mediaNavigationCoordinator: MediaNavigationCoordinator
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(viewModel.items) { item in
                    CarouselCard(item: item)
                        .onAppear {
                            viewModel.onAppear(item: item)
                        }
                        .onTapGesture {
                            mediaNavigationCoordinator.navigateDetail(media: item.mediaReference)
                        }
                        .padding(.all, 10)
                }
                
//                if store.isLoadingPage {
//                    ProgressView()
//                }
            }
        }
    }
}

//#if DEBUG
//struct PlainCarousel_Previews: PreviewProvider {
//    static var previews: some View {
//        PlainCarousel(viewModel: .init(mediaItems: [.mock, .mock2, .mock3], mediaStore: .mock()))
//            .frame(width: 400, height: 300)
//    }
//}
//#endif
//
