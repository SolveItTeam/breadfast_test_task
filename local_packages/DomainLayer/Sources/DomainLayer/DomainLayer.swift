import Foundation

/// Entry point for Domain layer
public enum DomainLayer {
    
}

//MARK: - Use cases factory
public extension DomainLayer {
    struct UseCasesFactory {
        private init(){}
        
        public static func makeAllPosts(postsRepository: PostsRepository, userRepostiory: UserRepository) -> GetAllPostsUseCase {
            GetAllPostsUseCaseImpl(
                postsRepository: postsRepository,
                userRepository: userRepostiory
            )
        }
        
        public static func makePostComments(_ repository: CommentsRepository) -> GetAllPostCommentsUseCase {
            GetAllPostCommentsUseCaseImpl(repository: repository)
        }
    }
}
