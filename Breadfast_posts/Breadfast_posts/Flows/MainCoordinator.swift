//
//  MainCoordinator.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit
import ArchitectureComponents

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
        let module = PostsListAssembly.make()
        router.set(controllers: [module])
    }
}
