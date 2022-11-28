import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var appDependencies: AppDependencies

    var body: some View {
        VStack {
            Spacer()
            DiscoverSection(viewModel: .init(context: .mostPopular,
                                             store: appDependencies.mediaStore))
            Spacer()
            DiscoverSection(viewModel:  .init(context: .nowPlaying,
                                              store: appDependencies.mediaStore))
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

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
            .configure()
    }
}
