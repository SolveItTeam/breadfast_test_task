//
//  PostDetailsAssembly.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit
import DomainLayer

struct PostDetailsAssembly {
    private init() {}
    
    static func make(post: TimelinePostEntity) -> UIViewController {
        let viewController = UIStoryboard.main.load(PostDetailsViewController.self)
        let viewModel = PostDetailsViewModel(
            post: post,
            useCase: DependencyFactory.shared.makePostCommentsUseCase()
        )
        viewController.viewModel = viewModel
        return viewController
    }
}
