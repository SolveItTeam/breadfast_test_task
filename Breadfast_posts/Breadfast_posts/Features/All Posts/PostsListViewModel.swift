//
//  AllPostsViewModel.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import ArchitectureComponents
import Extensions
import DomainLayer
import Combine

typealias PostsListViewState = LoadableSceneState<[PostsListCellProps]>

protocol PostsListViewModelInput: SceneViewLifecycleEvents {
    var viewStateSubject: CurrentValueSubject<PostsListViewState, Never> { get }
    func reloadPosts()
}

final class PostsListViewModel {
    private let useCase: GetAllPostsUseCase
    private let cancelBag: CancelBag
    
    var viewStateSubject: CurrentValueSubject<PostsListViewState, Never>
    
    // MARK: - Initialization
    init(useCase: GetAllPostsUseCase) {
        self.useCase = useCase
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
                    let props = posts.map({
                        PostsListCellProps(
                            authorID: "Author: \($0.userID)",
                            title: $0.title,
                            content: $0.content
                        )
                    })
                    self.viewStateSubject.value = .content(data: props)
                case .failure:
                    self.viewStateSubject.value = .error(error: "SOMETHING WRONG")
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
}
