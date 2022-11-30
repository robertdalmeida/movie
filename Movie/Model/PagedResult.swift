import Foundation

/// To accomodate paging results, the response from the service is stored in this type to maintain the current page and total pages.
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
