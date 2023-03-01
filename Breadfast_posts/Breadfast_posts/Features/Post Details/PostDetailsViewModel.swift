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

enum PostDetailsViewRows: Hashable {
    case post(PostsListCellProps)
    case comment(PostCommentCellProps)
}

typealias PostDetailsViewState = LoadableSceneState<[PostDetailsViewRows]>

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
    func makePostRow(_ post: PostEntity) -> PostDetailsViewRows {
        let props = PostsListCellProps(
            authorID: post.userID,
            title: post.title,
            content: post.content
        )
        return .post(props)
    }
    
    func makeCommentRows(_ comments: [PostCommentEntity]) -> [PostDetailsViewRows] {
        comments
            .lazy
            .map { PostCommentCellProps(authorName: $0.name, content: $0.content) }
            .map({ PostDetailsViewRows.comment($0) })
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
                    let commentRows = self.makeCommentRows(comments)
                    let newState = self.viewStateSubject.value
                    switch self.viewStateSubject.value {
                    case .content(let rows):
                        var newRows = rows + commentRows
                        self.viewStateSubject.value = .content(data: newRows)
                    default:
                        let postRow = self.makePostRow(post)
                        let rows = [postRow] + commentRows
                        self.viewStateSubject.value = .content(data: rows)
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
        let postRow = makePostRow(post)
        viewStateSubject.value = .content(data: [postRow])
        loadFor(post: post)
    }
    
    func reload() {
        viewStateSubject.value = .loading
        loadFor(post: post)
    }
}
