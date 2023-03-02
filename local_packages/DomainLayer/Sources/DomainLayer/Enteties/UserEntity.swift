import Foundation

public struct UserEntity: Identifiable {
    public typealias ID = Int
    
    public let id: ID
    public let name: String?
    public let email: String?
    
    public init(id: ID, name: String?, email: String?) {
        self.id = id
        self.name = name
        self.email = email
    }
    
    public static var placeholder: UserEntity {
        UserEntity(id: -1, name: "User not found", email: "example@email.com")
    }
}
