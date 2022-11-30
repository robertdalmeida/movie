import Foundation

extension PlainCarousel {
    @MainActor
    final class ViewModel: ObservableObject {
        enum State {
            case error
            case loading
            case loaded
        }
        @Published var items: [CarouselCard.Item]
        let mediaStore: MediaCategoryStoreProtocol
        @Published var state: State = .loading
        
        init(mediaStore: MediaCategoryStoreProtocol) {
            items = []
            self.mediaStore = mediaStore
            
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

        // MARK: - Pagination
        
        /// Appends the next page of movies to the current set of Items
        private func appendMoreMovies(_ movies: [Media]) {
            var theLastValidOrder = self.items.last?.id ?? 0
            theLastValidOrder += 1
            for i in 0..<movies.count {
                let new = CarouselCard.Item(order: theLastValidOrder,
                                            mediaReference: movies[i])
                items.append(new)
                theLastValidOrder += 1
            }
        }
        
        /// Whenever a card is displayed here we decide if we need to call the next page.
        func onAppear(item visibleItem: CarouselCard.Item) {
            let currentCacheCount = items.count
            guard let index = items.firstIndex(where: { item in
                item.id == visibleItem.id
            }) else { return }
            if (currentCacheCount - index) < 10 { // if it is the last few cards
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
