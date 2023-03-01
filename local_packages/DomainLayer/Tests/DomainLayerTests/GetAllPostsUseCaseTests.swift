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
        let repository = PostsRepositoryMock(scenario: scenario)
        let useCase = DomainLayer.UseCasesFactory.makeAllPosts(repository)
        
        useCase
            .invoke()
            .sink(receiveCompletion: { _ in }) { posts in
                print("value in emptyPosts")
                XCTAssertEqual(posts.isEmpty, expectedResult)
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
    
    func getAll() -> AnyPublisher<[PostEntity], Error> {
        Future<[PostEntity], Error> { [weak self] closure in
            guard let self = self else { return }
            
            switch self.scenario {
            case .emptyPosts:
                closure(.success([]))
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
                closure(.success(items))
            }
        }
        .eraseToAnyPublisher()
    }
}
