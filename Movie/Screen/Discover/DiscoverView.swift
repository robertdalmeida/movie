import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var appDependencies: AppDependencies

    var body: some View {
        VStack {
            HStack {
                Text("Discover Movies")
                    .applyAppStyle(.title)
            }
            Spacer()
            DiscoverSection(viewModel: .init(context: .mostPopular,
                                             store: appDependencies.mediaStore.popularMediaStore))
            Spacer()
            DiscoverSection(viewModel:  .init(context: .nowPlaying,
                                              store: appDependencies.mediaStore.nowPlayingMediaStore))
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
        DiscoverView()
            .configure()
    }
}
#endif
