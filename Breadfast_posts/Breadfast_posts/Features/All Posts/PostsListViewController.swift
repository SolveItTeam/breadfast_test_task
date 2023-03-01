//
//  AllPostsViewController.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit
import Extensions
import ArchitectureComponents

final class PostsListViewController: BaseViewController {
    // MARK: - Properties
    var viewModel: PostsListViewModelInput!
    private let dataSource = GenericTableViewDataSource<PostsListCellProps>()
    
    // MARK: - @IBOutlet's
    @IBOutlet private weak var noContentView: NoContentView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localization.allPosts.rawValue
        viewModel.viewDidLoad()
    }
    
    // MARK: - Setup
    override func setupDataSource() {
        dataSource.setup { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCellWithRegistration(
                type: PostsListCell.self,
                indexPath: indexPath
            )
            cell.fill(with: item)
            return cell
        } selectionHandler: { [weak self] indexPath in
            self?.viewModel.selectPost(at: indexPath)
        }
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
    
    override func setupInitialState() {
        showLoadingState()
    }
    
    // MARK: - State management
    override func bindToViewState() {
        viewModel
            .viewStateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                switch viewState {
                case .error(let text):
                    self?.showError(text)
                case .content(let items):
                    self?.showContent(items)
                case .loading:
                    self?.showLoadingState()
                }
            }
            .store(in: cancelBag)
    }
    
    // MARK: - Actions
    override func pullToRefreshTrigerred() {
        viewModel.reloadPosts()
    }
}

// MARK: - State management
private extension PostsListViewController {
    func showError(_ text: String) {
        showErrorAlert(message: text)
        tableView.refreshControl?.endRefreshing()
    }
    
    func showLoadingState() {
        tableView.refreshControl?.beginRefreshing()
        tableView.isHidden = false
        noContentView.isHidden = true
    }
    
    func showContent(_ items: [PostsListCellProps]) {
        tableView.refreshControl?.endRefreshing()
        dataSource.updateItems(items)
        tableView.reloadData()
        tableView.isHidden = items.isEmpty
    }
}
