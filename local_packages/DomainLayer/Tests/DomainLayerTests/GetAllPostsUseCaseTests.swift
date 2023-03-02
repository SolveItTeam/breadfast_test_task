//
//  GetAllPostsUseCaseTests.swift
//  
//
//  Created by Andrey on 01/03/2023.
//

import XCTest
import Combine
@testable import DomainLayer

final class GetAllPostsUseCaseTests: XCTestCase {
    enum Scenario {
        case emptyPosts
        case nonEmptyPosts
    }
    
    private var cancellables: Set<AnyCancellable>!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        super.tearDown()
        cancellables.removeAll()
    }
    
    // MARK: - Tests
    func testNonEmptyPostsList() {
        run(.nonEmptyPosts, shouldBeEmpty: false)
    }
    
    func testEmptyPostsList() {
        run(.emptyPosts, shouldBeEmpty: true)
    }
    
    private func run(_ scenario: Scenario, shouldBeEmpty expectedResult: Bool) {
        let postsRepository = PostsRepositoryMock(scenario: scenario)
        let userRepostiory = UserRepositoryMock()
        let useCase = DomainLayer.UseCasesFactory.makeAllPosts(
            postsRepository: postsRepository,
            userRepostiory: userRepostiory
        )
        
        useCase
            .invoke(pageNumber: 1)
            .sink(receiveCompletion: { _ in }) { response in
                print("value in emptyPosts")
                XCTAssertEqual(response.payload.isEmpty, expectedResult)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Mocks
private final class PostsRepositoryMock: PostsRepository {
    private let scenario: GetAllPostsUseCaseTests.Scenario
    
    init(scenario: GetAllPostsUseCaseTests.Scenario) {
        self.scenario = scenario
    }
    
    func getAll(page: Int) -> AnyPublisher<PaginatedEntity<[PostEntity]>, Error> {
        Future<PaginatedEntity<[PostEntity]>, Error> { [weak self] closure in
            guard let self = self else { return }
            
            switch self.scenario {
            case .emptyPosts:
                let response = PaginatedEntity<[PostEntity]>.init(
                    pagination: .init(currentPage: 1, totalPages: 1),
                    payload: []
                )
                closure(.success(response))
            case .nonEmptyPosts:
                let range = 0..<20
                let items = range.map { i in
                    PostEntity(
                        id: i + 1,
                        userID: i * 2 + 1,
                        title: "Post title \(i)",
                        content: "Post content \(0)"
                    )
                }
                let response = PaginatedEntity<[PostEntity]>.init(
                    pagination: .init(currentPage: 1, totalPages: 10),
                    payload: items
                )
                closure(.success(response))
            }
        }
        .eraseToAnyPublisher()
    }
}

private final class UserRepositoryMock: UserRepository {
    func getBy(_ id: UserEntity.ID) -> AnyPublisher<UserEntity, Never> {
        Future<UserEntity, Never> { closure in
            let entity = UserEntity(id: id, name: "Name \(id)", email: "email \(id)")
            closure(.success(entity))
        }
        .eraseToAnyPublisher()
    }
}
