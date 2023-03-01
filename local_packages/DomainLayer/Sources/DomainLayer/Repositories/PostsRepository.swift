import Foundation
import Combine

public protocol PostsRepository {
    func getAll(page: Int) -> AnyPublisher<PaginatedEntity<[PostEntity]>, Error>
}
