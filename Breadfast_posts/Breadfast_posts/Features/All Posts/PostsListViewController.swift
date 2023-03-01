//
//  AllPostsViewController.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit

final class PostsListViewController: UIViewController {
    // MARK: - Properties
    var viewModel: PostsListViewModelInput!
    
    // MARK: - UI
    @IBOutlet
    private weak var tableView: UITableView! {
        didSet {
            tableView.refreshControl = refreshControl
        }
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return control
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Actions
    @objc private func pullToRefresh() {
        viewModel.reloadPosts()
    }
    
    // MARK: - State management
}
