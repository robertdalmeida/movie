import SwiftUI

struct CarouselCard: View {
    enum Constants {
        static let cardSize: CGSize = CGSize(width: 180, height: 220)
        static let cornerRadius: CGFloat = 11.0
    }
    
    let item: Item
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
            VStack {
                SourcedImageView(imageSource: item.mediaReference.thumbnailImage,
                                 contentMode: .fill)
                .frame(width: Constants.cardSize.width,
                       height: Constants.cardSize.height - 40)
                .clipped()
                detailsView
            }
        }
        .frame(width: Constants.cardSize.width, height: Constants.cardSize.height)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .shadow(radius: 3.0)
    }
    
    @ViewBuilder
    var detailsView: some View {
        HStack {
            Text(item.title)
                .font(.subheadline)
                .bold()
                .padding([.leading])
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
            }
            .padding([.bottom, .leading, .trailing])
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
