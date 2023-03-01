import Foundation

/// Entry point for Domain layer
public enum DomainLayer {
    
}

//MARK: - Use cases factory
public extension DomainLayer {
    struct UseCasesFactory {
        private init(){}
        
        public static func makeAllPosts(_ repository: PostsRepository) -> GetAllPostsUseCase {
            GetAllPostsUseCaseImpl(repository: repository)
        }
        
        public static func makePostComments(_ repository: CommentsRepository) -> GetAllPostCommentsUseCase {
            GetAllPostCommentsUseCaseImpl(repository: repository)
        }
    }
}
