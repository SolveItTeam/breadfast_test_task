//
//  AllPostsViewModel.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import Foundation
import ArchitectureComponents
import Extensions
import DomainLayer
import Combine

typealias PostsListViewState = LoadableSceneState<[PostsListCellProps]>

protocol PostsListViewModelInput: SceneViewLifecycleEvents {
    var viewStateSubject: CurrentValueSubject<PostsListViewState, Never> { get }
    
    func reloadPosts()
    func selectPost(at indexPath: IndexPath)
}

final class PostsListViewModel {
    private let cancelBag: CancelBag
    
    private let useCase: GetAllPostsUseCase
    private var posts: [PostEntity]
    private let openPostDetailsAction: (PostEntity) -> Void
    
    var viewStateSubject: CurrentValueSubject<PostsListViewState, Never>
    
    // MARK: - Initialization
    init(useCase: GetAllPostsUseCase, openPostDetailsAction: @escaping (PostEntity) -> Void) {
        self.useCase = useCase
        self.openPostDetailsAction = openPostDetailsAction
        self.posts = []
        self.cancelBag = .init()
        self.viewStateSubject = .init(.loading)
    }
}

// MARK: - Private
private extension PostsListViewModel {
    func loadPosts() {
        viewStateSubject.value = .loading
        useCase
            .invoke()
            .toResult()
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let posts):
                    self.posts = posts
                    
                    let props = posts.map({
                        PostsListCellProps(
                            authorID: "Author ID: \($0.userID)",
                            title: $0.title,
                            content: $0.content
                        )
                    })
                    self.viewStateSubject.value = .content(data: props)
                case .failure:
                    self.viewStateSubject.value = .error(error: Localization.somethingWrongError.rawValue)
                }
            }
            .store(in: cancelBag)
    }
}

// MARK: - AllPostsViewModelInput
extension PostsListViewModel: PostsListViewModelInput {
    func viewDidLoad() {
        loadPosts()
    }
    
    func reloadPosts() {
        loadPosts()
    }
    
    func selectPost(at indexPath: IndexPath) {
        openPostDetailsAction(posts[indexPath.row])
    }
}
