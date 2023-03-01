import Combine
import Foundation

public protocol GetAllPostCommentsUseCase {
    func invoke(postID: PostEntity.ID) -> AnyPublisher<[PostCommentEntity], Error>
}

struct GetAllPostCommentsUseCaseImpl: GetAllPostCommentsUseCase {
    let repository: CommentsRepository
    
    func invoke(postID: PostEntity.ID) -> AnyPublisher<[PostCommentEntity], Error> {
        repository.getAll(for: postID)
    }
}
