import Foundation

public struct PaginationStateEntity {
    public let currentPage: Int
    public let totalPages: Int
    
    public init(currentPage: Int, totalPages: Int) {
        self.currentPage = currentPage
        self.totalPages = totalPages
    }
}

public struct PaginatedEntity<T> {
    public let pagination: PaginationStateEntity?
    public let payload: T
    
    public init(pagination: PaginationStateEntity?, payload: T) {
        self.pagination = pagination
        self.payload = payload
    }
}
