import Foundation
import Combine

public protocol PostsRepository {
    func getAll() -> AnyPublisher<[PostEntity], Error>
}
