import Foundation

protocol MediaService {
    func fetchMedia(page: Int) async throws -> (media:[Media], totalPages: Int?, currentPage: Int?)
}
