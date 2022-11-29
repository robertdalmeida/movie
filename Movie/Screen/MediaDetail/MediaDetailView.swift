import SwiftUI

struct MediaDetailView: View {
    
    enum Constants {
        static let favoriteButtonSize = CGSizeMake(25, 25)
    }
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var imageStore: ImageStore
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .loaded:
                ScrollView {
                    VStack{
                        mediaPoster
                        mediaTitleRow
                        releaseDateAndRating
                        genreView
                        movieDetails
                    }
                }
            case .error:
                ErrorView(message: "")
            }
        }
        .navigationTitle(viewModel.title)
    }
    
    // MARK: -  Container views
    
    var mediaPoster: some View {
        SourcedImageView(imageSource: viewModel.posterImage)
            .padding([.leading, .trailing, .top])
    }
    
    var releaseDateAndRating: some View {
        HStack {
            releaseDate
                .padding([.leading, .trailing])
            Spacer()
            userRating
        }
    }
    
    var genreView: some View {
        ScrollView(.horizontal, showsIndicators: false)  {
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
    
    var mediaTitleRow: some View {
        HStack {
            Text(viewModel.title)
                .applyAppStyle(.title)
                .padding([.leading, .trailing])
            Spacer()
            favoriteButton
                .padding([.leading, .trailing])
        }
    }
    var userRating: some View {
        HStack {
            CircularIndicator(progress: viewModel.userRating)
                .frame(width: 30, height: 30)
            Text("User Score")
                .font(.caption)
                .frame(width: 40)
                .padding([.trailing])
        }
    }
    var releaseDate: some View {
        HStack {
            if let releaseDate = viewModel.releaseDate {
                VStack {
                    HStack {
                        Text("Release date:")
                            .font(.footnote)
                        Spacer()
                    }
                    HStack {
                        Text(releaseDate, style: .date)
                        Spacer()
                    }
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

#if DEBUG
struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MediaDetailView(viewModel: .init(media: .mock,
                                         favoriteStore: .mock, mediaStore: .mock))
            .configure()
    }
}
#endif
