import Foundation
import Combine
import DomainLayer

final class UserRepositoryImpl {
    private let dataSource: APIDataSource
    
    init(dataSource: APIDataSource) {
        self.dataSource = dataSource
    }
}

// MARK: - UserRepository
extension UserRepositoryImpl: UserRepository {
    func getBy(_ id: UserEntity.ID) -> AnyPublisher<UserEntity, Never> {
        dataSource
            .send(UserResponse.self, endpoint: UsersEndPoint.getProfile(id: id))
            .map({ $0.data.toDomainEntity() })
            .replaceError(with: .placeholder)
            .eraseToAnyPublisher()
    }
}
