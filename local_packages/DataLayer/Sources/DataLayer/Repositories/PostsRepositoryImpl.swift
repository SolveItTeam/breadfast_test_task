import Foundation
import DomainLayer
import Combine

final class PostsRepositoryImpl {
    
}

// MARK: - PostsRepository
extension PostsRepositoryImpl: PostsRepository {
    func getAll() -> AnyPublisher<[PostEntity], Error> {
        Future<[PostEntity], Error> { closure in
            
        }.eraseToAnyPublisher()
    }
}
