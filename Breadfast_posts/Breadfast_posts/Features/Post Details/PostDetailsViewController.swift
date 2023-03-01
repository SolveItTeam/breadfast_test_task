//
//  PostCommentsViewController.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit
import Extensions

final class PostDetailsViewController: BaseViewController {
    var viewModel: PostDetailsViewModelInput!
    private let tableDataSource = PostDetailsTableDataSource()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        viewModel.viewDidLoad()
    }
    
    // MARK: - Setup
    override func setupDataSource() {
        tableView.dataSource = tableDataSource
    }
    
    override func setupInitialState() {
        tableView.refreshControl?.beginRefreshing()
    }
    
    // MARK: - State management
    override func bindToViewState() {
        viewModel
            .viewStateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                guard let self = self else { return }
                switch viewState {
                case .content(let sections):
                    self.tableDataSource.sections = sections
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                case .error(let message):
                    self.tableView.refreshControl?.endRefreshing()
                    self.showErrorAlert(message: message)
                case .loading:
                    self.tableView.refreshControl?.beginRefreshing()
                }
            }
            .store(in: cancelBag)
    }
    
    // MARK: - Actions
    override func pullToRefreshTrigerred() {
        viewModel.reload()
    }
}
