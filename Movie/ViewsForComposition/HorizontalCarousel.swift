//
//  HorizontalCarousel.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI


extension HorizontalCarousel {

    final class Store: ObservableObject {
        @Published var items: [CarouselCard.Item]

        init(movies: [Media]) {
            items = []
            for i in 0..<movies.count {
                let new = CarouselCard.Item(order: i,
                                            mediaReference: movies[i])
                items.append(new)
            }
        }
    }
}

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
                print("Movie:\(item) tapped")
                mediaNavigationCoordinator.openMediaDetail(media: item.mediaReference)
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
//        print("bob:", item, distance)
        return distance
    }
    
    func myXOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(store.items.count) * distance(item)
//        print("bob: angle", item, angle)

        return sin(angle) * 200
    }
    
}

struct HorizontalCarousel_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalCarousel(store: .init(movies: [.mock, .mock1, .mock2, .mock3, .mock4, .mock5, .mock6]))
    }
}
