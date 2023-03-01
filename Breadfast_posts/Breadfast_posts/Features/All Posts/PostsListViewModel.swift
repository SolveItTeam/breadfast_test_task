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

protocol PostsListViewModelInput: SceneViewLifecycleEvents {
    func reloadPosts()
}

final class PostsListViewModel {
    private let useCase: GetAllPostsUseCase
    private let cancelBag: CancelBag
    
    // MARK: - Initialization
    init(useCase: GetAllPostsUseCase) {
        self.useCase = useCase
        self.cancelBag = .init()
    }
}

// MARK: - Private
private extension PostsListViewModel {
    func loadPosts() {
        
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
