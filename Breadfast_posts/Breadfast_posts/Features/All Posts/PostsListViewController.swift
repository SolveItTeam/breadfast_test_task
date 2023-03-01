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
    private let dataSource = GenericTableViewDataSource<PostsListCellProps>()
    
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
        setupTableView()
        showInitialState()
        bindToViewState()
        viewModel.viewDidLoad()
    }
    
    private func setupTableView() {
        dataSource.setup { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCellWithRegistration(type: PostsListCell.self, indexPath: indexPath)
            cell.fill(with: item)
            return cell
        } selectionHandler: { [weak self] indexPath in
            self?.viewModel.selectPost(at: indexPath)
        }
        
        tableView.refreshControl = refreshControl
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
    
    // MARK: - Actions
    @objc private func pullToRefresh() {
        viewModel.reloadPosts()
    }
}

// MARK: - State management
private extension PostsListViewController {
    func showTableView() {
        tableView.isHidden = false
        noContentView.isHidden = true
    }
    
    func showInitialState() {
        refreshControl.beginRefreshing()
        noContentView.isHidden = true
    }
    
    func bindToViewState() {
        viewModel
            .viewStateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                switch viewState {
                case .error(let text):
                    self?.refreshControl.endRefreshing()
                    self?.showErrorAlert(message: text)
                case .content(let items):
                    self?.refreshControl.endRefreshing()
                    self?.dataSource.updateItems(items)
                    self?.tableView.reloadData()
                    
                    if items.isEmpty {
                        self?.tableView.isHidden = true
                        self?.noContentView.isHidden = false
                    } else {
                        self?.showTableView()
                    }
                case .loading:
                    self?.refreshControl.beginRefreshing()
                    self?.showTableView()
                }
            }
            .store(in: cancelBag)
    }
}
