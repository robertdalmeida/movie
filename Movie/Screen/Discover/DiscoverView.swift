import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var appDependencies: AppDependencies
    let popularMediaStore: MediaCategoryStoreProtocol
    let nowPlayingMediaStore: MediaCategoryStoreProtocol
    
    var body: some View {
        VStack {
            HStack {
                Text("Discover Movies")
                    .applyAppStyle(.title)
                    .padding([.top])
            }
            Spacer()
            DiscoverSection(viewModel: .init(context: .mostPopular,
                                             store: popularMediaStore))
            Spacer()
            DiscoverSection(viewModel:  .init(context: .nowPlaying,
                                              store: nowPlayingMediaStore))
            Spacer()
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
}

#if DEBUG
struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView(popularMediaStore: MockStore(),
                     nowPlayingMediaStore: MockStore())
    }
}
#endif
