import Foundation
import DomainLayer

struct PostsResponse: Codable {
    let id: Int
    let userID: Int
    let title: String
    let body: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case title, body
    }
}

// MARK: - DomainEntityConvertable
extension PostsResponse: DomainEntityConvertable {
    typealias DomainEntity = PostEntity
    
    func toDomainEntity() -> PostEntity {
        .init(id: id, userID: userID, title: title, content: body)
    }
}
