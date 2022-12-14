import SwiftUI

struct FavoriteRow: View {
    let item: Media
    var body: some View {
        HStack{
            AsyncImage(url: item.image) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                
            } placeholder: {
                Spacer()
                ProgressView()
                    .frame(width: 70, height: 70)
                Spacer()
            }
            .padding()
            
            Text(item.title)
                .applyAppStyle(.cellTitle)
            Spacer()
        }
    }
}

#if DEBUG
struct FavoriteRow_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteRow(item: .mock)
    }
}
#endif
