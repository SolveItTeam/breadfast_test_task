import Foundation
import DomainLayer

struct UserResponse: Codable {
    let id: Int
    let postID: Int
    let name: String
    let email: String
    let body: String

    enum CodingKeys: String, CodingKey {
        case id
        case postID = "post_id"
        case name, email, body
    }
}

// MARK: - DomainEntityConvertable
extension UserResponse: DomainEntityConvertable {
    typealias DomainEntity = UserEntity
    
    func toDomainEntity() -> UserEntity {
        .init(id: id, name: name, email: email)
    }
}
