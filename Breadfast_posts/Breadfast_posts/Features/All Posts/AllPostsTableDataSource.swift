//
//  AllPostsTableDataSource.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit

final class AllPostsTableDataSource: NSObject {
    var items = [PostsListCellProps]()
    var selectionHandler: ((IndexPath) -> Void)?
    var requestNextItemsHandler: (() -> Void)?
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AllPostsTableDataSource: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithRegistration(type: PostsListCell.self, indexPath: indexPath)
        cell.fill(with: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionHandler?(indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height - 50 {
            requestNextItemsHandler?()
        }
    }
}
