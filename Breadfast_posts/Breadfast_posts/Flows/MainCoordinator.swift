//
//  MainCoordinator.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit
import ArchitectureComponents
import DomainLayer

final class MainCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let router: Router
    
    // MARK: - Initialization
    init(window: UIWindow) {
        self.window = window
        let navigation = UINavigationController()
        self.router = Router(rootController: navigation)
        window.rootViewController = navigation

        super.init()
    }
    
    // MARK: - Flow
    override func start() {
        let module = PostsListAssembly.make { [weak self] post in
            self?.openDetails(for: post)
        }
        router.set(controllers: [module])
    }
    
    private func openDetails(for post: PostEntity) {
        let module = PostDetailsAssembly.make(post: post)
        router.push(module, animated: true)
    }
}
