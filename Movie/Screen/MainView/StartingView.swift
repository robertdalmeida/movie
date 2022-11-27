import SwiftUI

struct StartingView: View {
    @EnvironmentObject var appDependencies: AppDependencies
    @ObservedObject var viewModel: StartingViewModel
    @ObservedObject var mediaNavigationCoordinator = MediaNavigationCoordinator()
    
    var body: some View {
        NavigationStack(path: $mediaNavigationCoordinator.navigationPath) {
            ZStack {
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
            .navigationDestination(for: Media.self) {
                MovieDetailView(viewModel: .init(media: $0,
                                                 favoriteStoreService: appDependencies.favoriteService,
                                                 offline: false))
            }
            .environmentObject(mediaNavigationCoordinator)
        }
        .task {
            await viewModel.initiateStartSequence()
        }
    }
    
    // MARK: -  helper views
    var tabView: some View {
        TabView {
            DiscoverView()
                .tabItem {
                    Label(Localised.discoverTabBarItemTitle,
                          systemImage: "list.dash")
                }
                .environmentObject(appDependencies.favoriteService)

            FavoritesView(viewModel: .init(favoriteStoreService: appDependencies.favoriteService))
                .tabItem {
                    Label(Localised.favoriteTabBarItemTitle,
                          systemImage: "person.circle")
                }
                .environmentObject(appDependencies.favoriteService)
        }
    }
    
    var errorView: some View {
        ErrorView(message: "I don't have anything to display - keep tapping me to retry.")
            .onTapGesture {
                Task {
                    await viewModel.initiateStartSequence()
                }
            }
    }
    
    var loadingView: some View {
        ProgressView()
    }
}

struct StartingView_Previews: PreviewProvider {
    static var previews: some View {
        StartingView(viewModel: .init(appDependencies: .mock))
            .configure()
    }
}
