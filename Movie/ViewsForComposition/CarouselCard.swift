//
//  CarouselCard.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI

struct CarouselCard: View {
    let item: Item
    var body: some View {
        ZStack {
            AsyncImage(url: item.imageURL) { image in
                Text("")
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
//            RoundedRectangle(cornerRadius: 18)
//                .fill(item.color)
            Text(item.title)
                .padding()
        }
    }
}

extension CarouselCard {
    struct Item: Identifiable {
        var order: Int
        var title: String
        var imageURL: URL?
        var id: Int {
            order
        }

#if DEBUG
        static let mock = Item(order: 1, title: "Item Title", imageURL: .mockImageUrlBlackPanther)
#endif
    }
    
}

struct CarouselCard_Previews: PreviewProvider {
    static var previews: some View {
        CarouselCard(item: .mock)
        .configure()
    }
}
