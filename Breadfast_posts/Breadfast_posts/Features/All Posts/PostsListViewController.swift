//
//  AllPostsViewController.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit
import Extensions
import ArchitectureComponents

final class PostsListViewController: UIViewController {
    // MARK: - Properties
    var viewModel: PostsListViewModelInput!
    private let cancelBag = CancelBag()
    
    // MARK: - UI
    @IBOutlet private weak var noContentView: NoContentView!
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return control
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refreshControl
        bindToViewState()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Actions
    @objc private func pullToRefresh() {
        viewModel.reloadPosts()
    }
    
    // MARK: - State management
    private func bindToViewState() {
        viewModel
            .viewStateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                switch viewState {
                case .error:
                    self?.refreshControl.endRefreshing()
                    //TODO: Implement
                    break
                case .content(let items):
                    self?.refreshControl.endRefreshing()
                    //TODO: Set data to data source
                    self?.tableView.reloadData()
                    if items.isEmpty {
                        self?.tableView.isHidden = true
                        self?.noContentView.isHidden = false
                    } else {
                        self?.tableView.isHidden = false
                        self?.noContentView.isHidden = true
                    }
                case .loading:
                    self?.refreshControl.beginRefreshing()
                }
            }
            .store(in: cancelBag)
    }
}
