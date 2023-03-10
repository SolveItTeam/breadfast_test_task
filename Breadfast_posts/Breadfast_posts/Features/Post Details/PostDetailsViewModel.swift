//
//  PostCommentsViewModel.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import Foundation
import Combine
import DomainLayer
import ArchitectureComponents
import Extensions

enum PostDetailsViewSections: Hashable {
    case post([PostsListCellProps])
    case comments([PostCommentCellProps])
}

typealias PostDetailsViewState = LoadableSceneState<[PostDetailsViewSections]>

protocol PostDetailsViewModelInput: SceneViewLifecycleEvents {
    var title: String { get }
    var viewStateSubject: CurrentValueSubject<PostDetailsViewState, Never> { get }
    func reload()
}

final class PostDetailsViewModel {
    private let post: TimelinePostEntity
    private let useCase: GetAllPostCommentsUseCase
    private let cancelBag: CancelBag
    
    var title: String { post.item.title }
    var viewStateSubject: CurrentValueSubject<PostDetailsViewState, Never>
    
    //MARK: - Initialization
    init(post: TimelinePostEntity, useCase: GetAllPostCommentsUseCase) {
        self.post = post
        self.useCase = useCase
        self.cancelBag = .init()
        self.viewStateSubject = .init(.loading)
    }
}

// MARK: - State building
private extension PostDetailsViewModel {
    func makePostSection(_ post: TimelinePostEntity) -> PostDetailsViewSections {
        let props = PostsListCellProps(
            authorName: post.user.name,
            authorEmail: post.user.email,
            title: post.item.title,
            content: post.item.content
        )
        return .post([props])
    }
    
    func makeCommentSection(_ comments: [PostCommentEntity]) -> PostDetailsViewSections {
        let rows = comments.map { PostCommentCellProps(authorName: $0.name, content: $0.content) }
        return .comments(rows)
    }
}

// MARK: - Data flow
private extension PostDetailsViewModel {
    func loadFor(post: TimelinePostEntity) {
        useCase
            .invoke(postID: post.item.id)
            .toResult()
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let comments):
                    let commentSection = self.makeCommentSection(comments)
                    var newSections = [PostDetailsViewSections]()
                    switch self.viewStateSubject.value {
                    case .content(let sections):
                        newSections = sections + [commentSection]
                    default:
                        let postSection = self.makePostSection(post)
                        newSections = [postSection, commentSection]
                    }
                    self.viewStateSubject.value = .content(data: newSections)
                case .failure:
                    self.viewStateSubject.value = .error(error: Localization.somethingWrongError.rawValue)
                }
                
            }
            .store(in: cancelBag)
    }
}

// MARK: - PostCommentsViewModelInput
extension PostDetailsViewModel: PostDetailsViewModelInput {
    func viewDidLoad() {
        let postRow = makePostSection(post)
        viewStateSubject.value = .content(data: [postRow])
        loadFor(post: post)
    }
    
    func reload() {
        viewStateSubject.value = .loading
        loadFor(post: post)
    }
}
