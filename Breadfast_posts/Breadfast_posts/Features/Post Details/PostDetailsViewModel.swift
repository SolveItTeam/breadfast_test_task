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

// MARK: - PostCommentsViewModelInput
extension PostDetailsViewModel: PostDetailsViewModelInput {
    private func makeRows(from comments: [PostCommentEntity], post: PostEntity) -> [PostDetailsViewRows] {
        let postProps = PostsListCellProps(
            authorID: "Author ID:\(self.post.userID)",
            title: self.post.title,
            content: self.post.content
        )
        let commentRows = comments.lazy.map {
            PostCommentCellProps(authorName: $0.name, content: $0.content)
        }
        .map({ PostDetailsViewRows.comment($0) })
        
        return [.post(postProps)] + commentRows
    }
    
    func viewDidLoad() {
        useCase
            .invoke(postID: post.id)
            .toResult()
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let comments):
                    let rows = self.makeRows(from: comments, post: self.post)
                    self.viewStateSubject.value = .content(data: rows)
                case .failure:
                    self.viewStateSubject.value = .error(error: Localization.somethingWrongError.rawValue)
                }
                
            }
            .store(in: cancelBag)
    }
}
