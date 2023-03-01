//
//  PostCommentsViewModel.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import Foundation
import DomainLayer
import ArchitectureComponents
import Extensions

protocol PostCommentsViewModelInput: SceneViewLifecycleEvents {
    
}

final class PostCommentsViewModel {
    private let post: PostEntity
    private let useCase: GetAllPostCommentsUseCase
    private let cancelBag: CancelBag
    
    //MARK: - Initialization
    init(post: PostEntity, useCase: GetAllPostCommentsUseCase) {
        self.post = post
        self.useCase = useCase
        self.cancelBag = .init()
    }
}

// MARK: - PostCommentsViewModelInput
extension PostCommentsViewModel: PostCommentsViewModelInput {
    func viewDidLoad() {
        useCase
            .invoke(postID: post.id)
            .toResult()
            .sink { result in
                
            }
            .store(in: cancelBag)
    }
}
