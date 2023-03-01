//
//  GenericTableViewDataSource.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit

final class GenericTableViewDataSource<T>: NSObject, UITableViewDataSource, UITableViewDelegate {
    typealias CellFactory = (
        _ tableView: UITableView,
        _ indexPath: IndexPath,
        _ item: T
    ) -> UITableViewCell
    
    typealias SelectionHandler = (_ indexPath: IndexPath) -> Void
    
    private var items = [T]()
    private var cellFactory: CellFactory?
    private var selectionHandler: SelectionHandler?
    
    // MARK: - Lifecycle
    func setup(cellFactory: @escaping CellFactory, selectionHandler: SelectionHandler?) {
        self.cellFactory = cellFactory
        self.selectionHandler = selectionHandler
    }
    
    func updateItems(_ items: [T]) {
        self.items = items
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        return cellFactory?(tableView, indexPath, item) ?? UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionHandler?(indexPath)
    }
}
