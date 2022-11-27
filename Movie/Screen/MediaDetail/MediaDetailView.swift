import SwiftUI

struct MediaDetailView: View {
    
    enum Constants {
        static let favoriteButtonSize = CGSizeMake(30, 30)
    }
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
