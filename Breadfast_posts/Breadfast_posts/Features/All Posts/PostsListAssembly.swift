//
//  PostsListAssembly.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit
import DomainLayer

struct PostsListAssembly {
    private init(){}
    
    static func make(openPostDetailsAction: @escaping (PostEntity) -> Void) -> UIViewController {
        let viewController = UIStoryboard.main.load(PostsListViewController.self)
        let viewModel = PostsListViewModel(
            useCase: DependencyFactory.shared.makeAllPostsUseCase(),
            openPostDetailsAction: openPostDetailsAction
        )
        viewController.viewModel = viewModel
        return viewController
    }
}
