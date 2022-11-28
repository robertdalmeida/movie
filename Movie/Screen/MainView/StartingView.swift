import SwiftUI

/// The main view of the application that houses the tabview and the containing views.
struct StartingView: View {
    @EnvironmentObject var appDependencies: AppDependencies
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var mediaNavigationCoordinator = MediaNavigationCoordinator()
    
    var body: some View {
        NavigationStack(path: $mediaNavigationCoordinator.navigationPath) {
            ZStack{ view }
            .navigationDestination(for: Media.self) {
                MediaDetailView(viewModel: .init(media: $0,
                                                 favoriteStore: appDependencies.favoriteStore,
                                                 mediaStore: appDependencies.mediaStore))
            }
            .environmentObject(mediaNavigationCoordinator)
        }
        .task {
            await viewModel.initiateStartSequence()
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
            DiscoverView()
                .tabItem {
                    Label(Localised.discoverTabBarItemTitle,
                          systemImage: "list.dash")
                }
                .environmentObject(appDependencies.favoriteStore)

            FavoritesView(viewModel: .init(favoriteStoreService: appDependencies.favoriteStore))
                .tabItem {
                    Label(Localised.favoriteTabBarItemTitle,
                          systemImage: "person.circle")
                }
                .environmentObject(appDependencies.favoriteStore)
        }
    }
    
    private var errorView: some View {
        ErrorView(message: "I don't have anything to display - keep tapping me to retry.")
            .onTapGesture {
                Task {
                    await viewModel.initiateStartSequence()
                }
            }
    }
    
    private var loadingView: some View {
        ProgressView()
    }
}

struct StartingView_Previews: PreviewProvider {
    static var previews: some View {
        StartingView(viewModel: .init(appDependencies: .mock))
            .configure()
    }
}
