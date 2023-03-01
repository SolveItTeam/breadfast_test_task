import Foundation
import Combine

public protocol CommentsRepository {
    func getAll(for postID: PostEntity.ID) -> AnyPublisher<[PostCommentEntity], Error>
}
