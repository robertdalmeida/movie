import SwiftUI

struct MediaDetailView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            VStack{
                if viewModel.offline {
                    OfflineIndicator()
                        .ignoresSafeArea()
                }
                mediaPoster
                movieHeader
                movieDetails
            }
        }
        .navigationTitle(viewModel.title)
    }
    
    // MARK: -  Container views
    
    var mediaPoster: some View {
        AsyncImage(url: viewModel.image) { image in
            image
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
                .clipShape(RoundedRectangle(cornerRadius: 15.0))
        } placeholder: {
            Spacer()
            ProgressView()
            Spacer()
        }
        .padding()
    }
    
    var movieHeader: some View {
        HStack {
            mediaTitle
            Spacer()
            favoriteButton
        }
        .padding()
    }
    
    @ViewBuilder
    var movieDetails: some View {
        if let overView = viewModel.media.overview {
            Text(overView)
                .applyAppStyle(.readingContent)
                .padding()
        }
    }
    
    var mediaTitle: some View {
        VStack {
            HStack {
                Text(viewModel.title)
                    .applyAppStyle(.title)
                Spacer()
            }
            if let releaseDate = viewModel.releaseDate {
                HStack {
                    Text(releaseDate, style: .date)
                    Spacer()
                }
            }
        }
    }
    var favoriteButton: some View {
        Button {
            viewModel.favoriteButtonTapped()
        } label: {
            if viewModel.isFavorite {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 40, height: 40)

            } else {
                Image(systemName: "heart")
                    .resizable()
                    .frame(width: 40, height: 40)

            }
        }
    }
}


struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MediaDetailView(viewModel: .init(media: .mock,
                                         favoriteStoreService: .mock, offline: true))
            .configure()
    }
}
