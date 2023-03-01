//
//  GetAllPostCommentsUseCaseTests.swift
//  
//
//  Created by Andrey on 01/03/2023.
//

import XCTest
import Combine
@testable import DomainLayer

final class GetAllPostCommentsUseCaseTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = .init()
    
    override func tearDown() {
        super.tearDown()
        cancellables.removeAll()
    }
    
    func testLoadCommentsForPost() {
        let repository = CommentsRepositoryMock()
        let useCase = DomainLayer.UseCasesFactory.makePostComments(repository)
        let postID = 1
        useCase
            .invoke(postID: postID)
            .sink(receiveCompletion: { _ in }) { comments in
                for comment in comments {
                    XCTAssertEqual(comment.postID, postID)
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - Mocks
private final class CommentsRepositoryMock: CommentsRepository {
    func getAll(for postID: PostEntity.ID) -> AnyPublisher<[PostCommentEntity], Error> {
        Future<[PostCommentEntity], Error> { closure in
            let range = 0..<20
            let comments = range.map { i in
                PostCommentEntity(
                    id: i + 1,
                    postID: postID,
                    name: "name \(0)",
                    email: "email\(i)@example.com",
                    content: "content \(i)"
                )
            }
            closure(.success(comments))
        }
        .eraseToAnyPublisher()
    }
}
