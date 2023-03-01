//
//  File.swift
//  
//
//  Created by Andrey on 01/03/2023.
//

import Foundation
import Combine
import DomainLayer

final class CommentsRepositoryImpl {
    private let dataSource: APIDataSource
    
    init(dataSource: APIDataSource) {
        self.dataSource = dataSource
    }
}

// MARK: - CommentsRepository
extension CommentsRepositoryImpl: CommentsRepository {
    func getAll(for postID: PostEntity.ID) -> AnyPublisher<[PostCommentEntity], Error> {
        dataSource
            .send([PostCommentResponse].self, endpoint: CommentsEndPoint.getCommentsForPost(id: postID))
            .map({ $0.data })
            .map({ $0.map({ $0.toDomainEntity() }) })
            .eraseToAnyPublisher()
    }
}
