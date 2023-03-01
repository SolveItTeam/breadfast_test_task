import Foundation
import DomainLayer
import Combine

final class PostsRepositoryImpl {
    private let dataSource: APIDataSource
    
    init(dataSource: APIDataSource) {
        self.dataSource = dataSource
    }
}

// MARK: - PostsRepository
extension PostsRepositoryImpl: PostsRepository {
    func getAll(page: Int) -> AnyPublisher<PaginatedEntity<[PostEntity]>, Error> {
        dataSource
            .send([PostsResponse].self, endpoint: PostsEndPoint.getAllPosts(page: page))
            .map { response -> PaginatedEntity<[PostEntity]> in
                return .init(
                    pagination: response.pagination,
                    payload: response.data.map({ $0.toDomainEntity() })
                )
            }
            .eraseToAnyPublisher()
    }
}
