import SwiftUI


struct PlainCarousel: View {
    @StateObject var viewModel: ViewModel
    @EnvironmentObject var mediaNavigationCoordinator: MediaNavigationCoordinator
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(viewModel.items) { item in
                    CarouselCard(item: item)
                        .onAppear {
                            viewModel.onAppear(item: item)
                        }
                        .onTapGesture {
                            mediaNavigationCoordinator.navigateDetail(media: item.mediaReference)
                        }
                        .padding(.all, 10)
                }
                if viewModel.state == .loading {
                    ProgressView()
                }
            }
        }
        .shadow(radius: 10)
    }
}

#if DEBUG
struct PlainCarousel_Previews: PreviewProvider {
    static var previews: some View {
        PlainCarousel(viewModel: .init(mediaStore: MockStore()))
    }
}

struct MockStore: MediaCategoryStoreProtocol {
            var movies: ServicedData<PagedResult> = .data(.init(currentPage: 1,
                                                                totalPages: 10,
                                                                movies: [.mock, .mock1]))
    
    func initialFetch() async -> ServicedData<[Media]> {
        .data([.mock, .mock1])
    }
    
    func fetchMore() async -> ServicedData<[Media]> {
        .data([.mock, .mock1])
    }
}
#endif

