//
//  File.swift
//  
//
//  Created by Andrey on 01/03/2023.
//

import Foundation
import DomainLayer

struct PostCommentResponse: Codable {
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
extension PostCommentResponse: DomainEntityConvertable {
    typealias DomainEntity = PostCommentEntity
    
    func toDomainEntity() -> PostCommentEntity {
        .init(id: self.id, postID: self.postID, name: self.name, email: self.email, content: self.body)
    }
}
