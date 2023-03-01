import Foundation

public struct PostCommentEntity: Identifiable {
    public typealias ID = Int
    
    public let id: ID
    public let postID: PostEntity.ID
    public let name: String
    public let email: String
    public let content: String
    
    public init(id: ID, postID: PostEntity.ID, name: String, email: String, content: String) {
        self.id = id
        self.postID = postID
        self.name = name
        self.email = email
        self.content = content
    }
}
