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
    func getAll() -> AnyPublisher<[PostEntity], Error> {
        dataSource
            .send([PostsResponse].self, endpoint: PostsEndPoint.getAllPosts)
            .map({ $0.map({ $0.toDomainEntity() }) })
            .eraseToAnyPublisher()
    }
}
