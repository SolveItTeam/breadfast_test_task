import Foundation

public struct PostEntity: Identifiable {
    public typealias ID = Int
    
    public let id: ID
    public let userID: Int
    public let title: String
    public let content: String
    
    public init(id: ID, userID: Int, title: String, content: String) {
        self.id = id
        self.userID = userID
        self.title = title
        self.content = content
    }
}
