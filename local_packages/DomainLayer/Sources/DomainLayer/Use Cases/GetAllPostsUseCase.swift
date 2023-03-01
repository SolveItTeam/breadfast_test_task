import Foundation
import Combine

public protocol GetAllPostsUseCase {
    func invoke() -> AnyPublisher<[PostEntity], Error>
}

struct GetAllPostsUseCaseImpl: GetAllPostsUseCase {
    let repository: PostsRepository
    
    func invoke() -> AnyPublisher<[PostEntity], Error> {
        repository.getAll()
    }
}
