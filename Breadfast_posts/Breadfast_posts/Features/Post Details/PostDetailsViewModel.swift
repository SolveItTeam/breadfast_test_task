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
    private let post: PostEntity
    private let useCase: GetAllPostCommentsUseCase
    private let cancelBag: CancelBag
    
    var title: String { post.title }
    var viewStateSubject: CurrentValueSubject<PostDetailsViewState, Never>
    
    //MARK: - Initialization
    init(post: PostEntity, useCase: GetAllPostCommentsUseCase) {
        self.post = post
        self.useCase = useCase
        self.cancelBag = .init()
        self.viewStateSubject = .init(.loading)
    }
}

// MARK: - State building
private extension PostDetailsViewModel {
    func makePostSection(_ post: PostEntity) -> PostDetailsViewSections {
        let props = PostsListCellProps(
            authorID: post.userID,
            title: post.title,
            content: post.content
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
    func loadFor(post: PostEntity) {
        useCase
            .invoke(postID: post.id)
            .toResult()
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let comments):
                    let commentSection = self.makeCommentSection(comments)
                    let newState = self.viewStateSubject.value
                    switch self.viewStateSubject.value {
                    case .content(let sections):
                        let newSections = sections + [commentSection]
                        self.viewStateSubject.value = .content(data: newSections)
                        break
                    default:
                        let postSection = self.makePostSection(post)
                        self.viewStateSubject.value = .content(data: [postSection, commentSection])
                    }
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
