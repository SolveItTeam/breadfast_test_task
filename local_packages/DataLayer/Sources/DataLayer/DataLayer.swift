import DomainLayer
import Foundation

/// Entry point to an application Data layer
public struct DataLayer {
    private static var apiDataSource: APIDataSource!
    
    static let itemsPerPage = 20
    
    public static func set(baseURL: URL, token: String) {
        apiDataSource = .init(
            token: token,
            baseURL: baseURL,
            mapper: NetworkResponseMapper(),
            mappingQueue: .global(qos: .background)
        )
    }
}

public extension DataLayer {
    struct RepositoryFactory {
        private init() {}
        
        public static func makePosts() -> PostsRepository {
            PostsRepositoryImpl(dataSource: DataLayer.apiDataSource)
        }
        
        public static func makeComments() -> CommentsRepository {
            CommentsRepositoryImpl(dataSource: DataLayer.apiDataSource)
        }
        
        public static func makeUser() -> UserRepository {
            UserRepositoryImpl(dataSource: DataLayer.apiDataSource)
        }
    }
}
