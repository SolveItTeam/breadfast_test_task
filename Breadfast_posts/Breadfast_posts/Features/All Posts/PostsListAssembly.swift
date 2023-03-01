//
//  PostsListAssembly.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit

struct PostsListAssembly {
    private init(){}
    
    static func make() -> UIViewController {
        let viewController = UIStoryboard.main.load(PostsListViewController.self)
        let viewModel = PostsListViewModel(useCase: DependencyFactory.shared.makeAllPostsUseCase())
        viewController.viewModel = viewModel
        return viewController
    }
}
