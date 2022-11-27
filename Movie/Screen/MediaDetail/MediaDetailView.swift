import SwiftUI

struct MediaDetailView: View {
    
    enum Constants {
        static let favoriteButtonSize = CGSizeMake(30, 30)
    }
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            VStack{
                mediaPoster
                movieHeader
                genreView
                movieDetails
            }
        }
        .navigationTitle(viewModel.title)
    }
    
    // MARK: -  Container views
    
    var mediaPoster: some View {
        ZStack {
            AsyncImage(url: viewModel.image) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
            } placeholder: {
                Spacer()
                ProgressView()
                Spacer()
            }
            .padding()
        }

        
    }
    
    var movieHeader: some View {
        HStack {
            mediaTitle
            Spacer()
            favoriteButton
        }
        .padding()
    }
    
    var genreView: some View {
        HStack {
            if let genres = viewModel.media.genres {
                ForEach(genres, id: \.self){ genre in
                    Text(genre)
                        .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(.systemGray), lineWidth: 1)
                        )

                }
                Spacer()
            }
        }
        .padding([.leading, .trailing])
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
            Task {
                await viewModel.favoriteButtonTapped()
            }
        } label: {
            switch viewModel.favoriteButtonState {
            case .notAFavorite:
                Image(systemName: "heart")
                    .resizable()
                    .transition(.scale)

            case .favorite:
                Image(systemName: "heart.fill")
                    .resizable()
                    .transition(.scale)

            case .inProgress:
                ProgressView()
            }
        }
        .frame(width: Constants.favoriteButtonSize.width, height: Constants.favoriteButtonSize.height)
        
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MediaDetailView(viewModel: .init(media: .mock,
                                         favoriteStoreService: .mock, offline: true))
            .configure()
    }
}
