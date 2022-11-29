import Foundation

final class PagedResult {
    var currentPage = 1
    var totalPages: Int = 1
    var movies: [Media] = []
    init(currentPage: Int = 1, totalPages: Int = 1, movies: [Media] = []) {
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.movies = self.movies + movies
    }
}
