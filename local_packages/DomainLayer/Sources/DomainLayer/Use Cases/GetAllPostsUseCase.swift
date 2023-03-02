import Foundation
import Combine

public protocol GetAllPostsUseCase {
    func invoke(pageNumber: Int) -> AnyPublisher<PaginatedEntity<[TimelinePostEntity]>, Error>
}

final class GetAllPostsUseCaseImpl {
    // MARK: - Properties
    private let postsRepository: PostsRepository
    private let userRepository: UserRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(postsRepository: PostsRepository, userRepository: UserRepository) {
        self.postsRepository = postsRepository
        self.userRepository = userRepository
    }
}

// MARK: - Private
private extension GetAllPostsUseCaseImpl {
    func makeProfilesPublisher(from posts: [PostEntity]) -> AnyPublisher<[UserEntity], Never> {
        let userProfiles = posts.lazy
                                .map({ $0.userID })
                                .map({ self.userRepository.getBy($0) })
        return Publishers.MergeMany(userProfiles).collect().eraseToAnyPublisher()
    }
    
    func makeTimelineObjectsFrom(_ posts: [PostEntity], users: [UserEntity]) -> [TimelinePostEntity] {
        var result = [TimelinePostEntity]()
        
        for post in posts {
            let desiredUser = users.first(where: { $0.id == post.userID })
            let timeLineObject = TimelinePostEntity(
                item: post,
                user: desiredUser ?? .placeholder
            )
            result.append(timeLineObject)
        }
        
        return result
    }
    
    func loadPosts(page: Int, resultHandler: @escaping (Result<PaginatedEntity<[PostEntity]>, Error>) -> Void) {
        postsRepository
            .getAll(page: page)
            .sink { completion in
                switch completion {
                case .failure(let e):
                    resultHandler(.failure(e))
                case .finished:
                    break
                }
            } receiveValue: { postResult in
                resultHandler(.success(postResult))
            }
            .store(in: &self.cancellables)
    }
}

// MARK: - GetAllPostsUseCase
extension GetAllPostsUseCaseImpl: GetAllPostsUseCase {
    func invoke(pageNumber: Int) -> AnyPublisher<PaginatedEntity<[TimelinePostEntity]>, Error> {
        Future<PaginatedEntity<[TimelinePostEntity]>, Error> { [weak self] closure in
            guard let self = self else { return }
            
            self.loadPosts(page: pageNumber) { result in
                switch result {
                case .success(let success):
                    let usersPublisher = self.makeProfilesPublisher(from: success.payload)
                    usersPublisher.sink { users in
                        let timelineObjects = self.makeTimelineObjectsFrom(success.payload, users: users)
                        let paginatedTimeline = PaginatedEntity<[TimelinePostEntity]>.init(
                            pagination: success.pagination,
                            payload: timelineObjects
                        )
                        closure(.success(paginatedTimeline))
                    }
                    .store(in: &self.cancellables)
                case .failure(let failure):
                    closure(.failure(failure))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
