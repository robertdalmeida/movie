import SwiftUI

/// Attempted a fancy Carousel playing with the opacity and positioning. Couldn't implement pagination in time, also the memory impact of this would have been greater. 
struct HorizontalCarousel: View {
    @ObservedObject var store: Store
    @EnvironmentObject var mediaNavigationCoordinator: MediaNavigationCoordinator

    @State private var snappedItem = 0.0
    @State private var draggingItem = 0.0
    
    func cardCarousel(_ item: CarouselCard.Item) -> some View {
        CarouselCard(item: item)
            .scaleEffect(1.0 - abs(distance(item.order)) * 0.2 )
            .opacity(1.0 - abs(distance(item.order)) * 0.3 )
            .offset(x: myXOffset(item.order), y: 0)
            .zIndex(1.0 - abs(distance(item.order)) * 0.1)
            .onTapGesture {
                mediaNavigationCoordinator.navigateDetail(media: item.mediaReference)
            }

    }
    
    var body: some View {
        ZStack {
            ForEach(store.items) { item in
                cardCarousel(item)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    draggingItem = snappedItem + value.translation.width / 100
                }
                .onEnded { value in
                    withAnimation {
                        draggingItem = snappedItem + value.predictedEndTranslation.width / 100
                        draggingItem = round(draggingItem).remainder(dividingBy: Double(store.items.count))
                        snappedItem = draggingItem
                    }
                }
        )
    }
    
    func distance(_ item: Int) -> Double {
        let distance = (draggingItem - Double(item)).remainder(dividingBy: Double(store.items.count))
        return distance
    }
    
    func myXOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(store.items.count) * distance(item)
        return sin(angle) * 200
    }
    
}

extension HorizontalCarousel {
    final class Store: ObservableObject {
        @Published var items: [CarouselCard.Item]
        let mediaStore: MediaCategoryStoreProtocol

        init(mediaStore: MediaCategoryStoreProtocol) {
            self.mediaStore = mediaStore
            items = []
            
            switch mediaStore.movies {
            case .uninitalized, .error:
                break
            case .data(let pagedResult):
                for i in 0..<pagedResult.movies.count {
                    let new = CarouselCard.Item(order: i,
                                                mediaReference: pagedResult.movies[i])
                    items.append(new)
                    
                }
            }
        }
    }
}


#if DEBUG
struct HorizontalCarousel_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalCarousel(store: .init(mediaStore: MediaStore.mock.nowPlayingMediaStore))
            .frame(width: 400, height: 300)
    }
}
#endif
