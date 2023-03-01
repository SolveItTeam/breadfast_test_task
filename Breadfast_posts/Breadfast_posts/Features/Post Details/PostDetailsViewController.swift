//
//  PostCommentsViewController.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit
import Extensions

final class PostDetailsViewController: UIViewController {
    var viewModel: PostDetailsViewModelInput!
    private let cancelBag = CancelBag()
    private let dataSource = GenericTableViewDataSource<PostDetailsViewRows>()
    
    // MARK: - @IBOutlet's
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindToViewState()
        viewModel.viewDidLoad()
    }
    
    private func setupTableView() {
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        dataSource.setup(cellFactory: { tableView, indexPath, item in
            switch item {
            case .post(let props):
                let cell = tableView.dequeueReusableCellWithRegistration(
                    type: PostFullContentCell.self,
                    indexPath: indexPath
                )
                cell.fill(with: props)
                return cell
            case .comment(let props):
                let cell = tableView.dequeueReusableCellWithRegistration(
                    type: PostCommentCell.self,
                    indexPath: indexPath
                )
                cell.fill(with: props)
                return cell
            }
            
        }, selectionHandler: nil)
    }
}

// MARK: - State management
private extension PostDetailsViewController {
    func bindToViewState() {
        title = viewModel.title
        
        viewModel
            .viewStateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                guard let self = self else { return }
                switch viewState {
                case .content(let rows):
                    self.dataSource.updateItems(rows)
                    self.tableView.reloadData()
                case .error(let message):
                    self.showErrorAlert(message: message)
                case .loading:
                    break
                }
            }
            .store(in: cancelBag)
    }
}
