import SwiftUI

final class MediaNavigationCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    func openMediaDetail(media: Media) {
        navigationPath.append(media)
    }
}

struct StartingView: View {
    @EnvironmentObject var appConfiguration: AppConfiguration
    @StateObject var viewModel: StartingViewModel = StartingViewModel()
    @ObservedObject var mediaNavigationCoordinator = MediaNavigationCoordinator()
    
    var body: some View {
        NavigationStack(path: $mediaNavigationCoordinator.navigationPath) {
            ZStack {
                switch viewModel.state {
                case .dataRecieved:
                    TabView {
                        DiscoverView()
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

                case .error:
                    ErrorView()
                        .onTapGesture {
                            fectchInitializationData()
                        }
                case .loading:
                    ProgressView()
                }
            }
            .navigationDestination(for: Media.self) { media in
                MovieDetailView(media: media)
            }.environmentObject(mediaNavigationCoordinator)
        }
        .task {
            fectchInitializationData()
        }
    }
    
    func fectchInitializationData() {
        Task {
            await viewModel.fetchData(using: appConfiguration.storeService)
        }
    }
}

struct StartingView_Previews: PreviewProvider {
    static var previews: some View {
        StartingView()
            .configure()
    }
}
