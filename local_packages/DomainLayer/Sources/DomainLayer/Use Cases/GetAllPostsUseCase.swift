import Foundation
import Combine

public protocol GetAllPostsUseCase {
    func invoke(pageNumber: Int) -> AnyPublisher<PaginatedEntity<[PostEntity]>, Error>
}

struct GetAllPostsUseCaseImpl: GetAllPostsUseCase {
    let repository: PostsRepository
    
    func invoke(pageNumber: Int) -> AnyPublisher<PaginatedEntity<[PostEntity]>, Error> {
        repository.getAll(page: pageNumber)
    }
}
