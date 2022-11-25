import SwiftUI

struct StartingView: View {
    @EnvironmentObject var appConfiguration: AppConfiguration
    @StateObject var viewModel: StartingViewModel = StartingViewModel()
    
    var body: some View {
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
