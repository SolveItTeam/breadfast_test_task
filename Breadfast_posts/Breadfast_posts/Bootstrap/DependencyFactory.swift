//
//  DIContainer.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import Foundation
import DomainLayer
import DataLayer

final class DependencyFactory {
    static let shared = DependencyFactory()
    
    private init() {
        DataLayer.set(baseURL: AppEnvironment.baseURL, token: AppEnvironment.apiToken)
    }
    
    func makeAllPostsUseCase() -> GetAllPostsUseCase {
        DomainLayer.UseCasesFactory.makeAllPosts(DataLayer.RepositoryFactory.makePosts())
    }
}