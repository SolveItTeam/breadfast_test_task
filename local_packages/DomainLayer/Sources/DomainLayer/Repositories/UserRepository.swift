import Foundation
import Combine

public protocol UserRepository {
    func getBy(_ id: UserEntity.ID) -> AnyPublisher<UserEntity, Never>
}
