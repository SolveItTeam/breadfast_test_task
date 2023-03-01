import Foundation

enum PaginationKeys: String {
    case responseHeaderCurrentPage = "x-pagination-page"
    case responseHeaderTotalPages = "x-pagination-pages"
    case requestPath = "per_page"
}
