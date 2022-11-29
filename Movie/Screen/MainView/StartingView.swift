import SwiftUI

/// The main view of the application that houses the tabview and the containing views.
struct StartingView: View {
    // MARK: -  Environment
    @EnvironmentObject var favoriteStore: FavoritesStore
    @EnvironmentObject var mediaStore: MediaStore
    
    // MARK: -  Owned
    @StateObject var viewModel: ViewModel = ViewModel()
    @StateObject var mediaNavigationCoordinator = MediaNavigationCoordinator()
    
    // MARK: -  View
    var body: some View {
        NavigationStack(path: $mediaNavigationCoordinator.navigationPath) {
            ZStack{ view }
            .navigationDestination(for: Media.self) {
                MediaDetailView(viewModel: .init(media: $0,
                                                 favoriteStore: favoriteStore,
                                                 mediaStore: mediaStore))
            }
            .environmentObject(mediaNavigationCoordinator)
        }
        .task {
            await viewModel.initiateStartSequence(mediaStore: mediaStore,
                                                  favoriteStore: favoriteStore)
        }
        .background{
            LinearGradient(gradient: Gradient(colors: [AppThemeColor.themeColor,
                                                       Color(.systemBackground),
                                                       AppThemeColor.themeColor,
                                                       Color(.systemBackground),
                                                       AppThemeColor.themeColor]),
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
        }
    }
    
    // MARK: -  helper views
    
    @ViewBuilder
    private var view: some View {
        switch viewModel.state {
        case .dataRecieved,
                .showLocalData:
            tabView
        case .error:
            errorView
        case .loading:
            loadingView
        }
    }
    
    private var tabView: some View {
        TabView {
            DiscoverView(popularMediaStore: mediaStore.popularMediaStore,
                         nowPlayingMediaStore: mediaStore.nowPlayingMediaStore)
                .tabItem {
                    Label(Localised.discoverTabBarItemTitle,
                          systemImage: "list.dash")
                }

            FavoritesView()
                .tabItem {
                    Label(Localised.favoriteTabBarItemTitle,
                          systemImage: "person.circle")
                }
        }
    }
    
    private var errorView: some View {
        ErrorView(message: "I don't have anything to display - keep tapping me to retry.")
            .onTapGesture {
                Task {
                    await viewModel.initiateStartSequence(mediaStore: mediaStore,
                                                          favoriteStore: favoriteStore)
                }
            }
    }
    
    private var loadingView: some View {
        ProgressView()
    }
}
#if DEBUG
struct StartingView_Previews: PreviewProvider {
    static var previews: some View {
        StartingView(viewModel: .init())
    }
}
#endif
