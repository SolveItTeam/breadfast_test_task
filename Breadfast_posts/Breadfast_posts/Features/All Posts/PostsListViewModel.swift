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
    
    func requestNextPostsPage()
    func reloadPosts()
    func selectPost(at indexPath: IndexPath)
}

final class PostsListViewModel {
    private let cancelBag: CancelBag
    
    private let useCase: GetAllPostsUseCase
    private var paginationCursor: PaginationCursor
    private var posts: [TimelinePostEntity]
    
    private let openPostDetailsAction: (TimelinePostEntity) -> Void
    
    var viewStateSubject: CurrentValueSubject<PostsListViewState, Never>
    
    // MARK: - Initialization
    init(useCase: GetAllPostsUseCase, openPostDetailsAction: @escaping (TimelinePostEntity) -> Void) {
        self.useCase = useCase
        self.posts = []
        
        self.cancelBag = .init()
        
        self.paginationCursor = .init()
        self.openPostDetailsAction = openPostDetailsAction
        self.viewStateSubject = .init(.loading)
    }
}

// MARK: - Private
private extension PostsListViewModel {
    func loadPosts() {
        guard let page = paginationCursor.nextPage else { return }
        useCase
            .invoke(pageNumber: page)
            .toResult()
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.posts += response.payload
                    let cellProps = self.posts.map { entity in
                        PostsListCellProps(
                            authorName: entity.user.name,
                            authorEmail: entity.user.email,
                            title: entity.item.title,
                            content: entity.item.content
                        )
                    }
                    self.viewStateSubject.value = .content(data: cellProps)
                    if let paginationUpdate = response.pagination {
                        self.paginationCursor.update(paginationUpdate)
                    }
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
        viewStateSubject.value = .loading
        loadPosts()
    }
    
    func reloadPosts() {
        posts.removeAll()
        paginationCursor.reset()
        viewStateSubject.value = .loading
        loadPosts()
    }
    
    func requestNextPostsPage() {
        switch viewStateSubject.value {
        case .content:
            loadPosts()
        default:
            break
        }
    }
    
    func selectPost(at indexPath: IndexPath) {
        openPostDetailsAction(posts[indexPath.row])
    }
}
