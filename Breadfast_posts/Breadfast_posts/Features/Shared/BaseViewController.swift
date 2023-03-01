//
//  BaseViewController.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit
import Extensions

class BaseViewController: UIViewController {
    let cancelBag = CancelBag()
    
    // MARK: - @IBOutlet's
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = .init(string: Localization.loading.rawValue)
            refreshControl.addTarget(self, action: #selector(pullToRefreshTrigerred), for: .valueChanged)
            tableView.refreshControl = refreshControl
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        setupInitialState()
        bindToViewState()
    }
    
    // MARK: - Setup
    open func setupDataSource() {
        
    }
    
    // MARK: - State management
    func setupInitialState() {
        
    }
    
    open func bindToViewState() {
        
    }
    
    // MARK: - Actions
    @objc func pullToRefreshTrigerred() {
        
    }
}
