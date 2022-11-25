//
//  CarouselCard.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI

struct CarouselCard: View {
    
    enum Constants {
        static let frame = CGSizeMake(250, 300)
        static let imageFrame = CGSizeMake(frame.width, 200)
        static let cornerRadius: CGFloat = 11.0
    }
    
    let item: Item
    var body: some View {
        ZStack {
//            LinearGradient(gradient: Gradient(colors: [Color(.lightGray), .white, Color(.lightGray), .white, Color(.lightGray)]),
//                           startPoint: .top,
//                           endPoint: .bottom)
            Color(.white)
            VStack {
                AsyncImage(url: item.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: Constants.imageFrame.width,
                               height: Constants.imageFrame.height,
                               alignment: .top)
                        .clipped()
                        
                } placeholder: {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                detailsView
            }
            .padding(.bottom)
        }
        .frame(width: Constants.frame.width, height: Constants.frame.height)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .shadow(radius: 3.0)
    }
    
    @ViewBuilder
    var detailsView: some View {
        HStack {
            Text(item.title)
                .font(.headline)
                .bold()
                .truncationMode(.tail)
                .padding([.leading, .top])
                .scaledToFit()
                .lineLimit(2)
                .allowsTightening(true)
            Spacer()
        }
        if let releaseDate = item.releaseDate {
            HStack {
                Text(releaseDate, style: .date)
                    .foregroundColor(.secondary)
                    .font(.caption)
                Spacer()
            }.padding([.bottom, .leading, .trailing])
        }
    }
}

extension CarouselCard {
    struct Item: Identifiable {
        let order: Int
        var title: String {
            mediaReference.title
        }
        var imageURL: URL? {
            mediaReference.image
        }
        var releaseDate: Date? {
            mediaReference.releaseDate
        }
        var id: Int {
            order
        }
        
        var mediaReference: Media

#if DEBUG
        static let mock = Item(order: 1,
                               mediaReference: .mock)
#endif
    }
    
}

struct CarouselCard_Previews: PreviewProvider {
    static var previews: some View {
        CarouselCard(item: .mock)
        .configure()
    }
}
