//
//  PostDetailsTableDataSource.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit

final class PostDetailsTableDataSource: NSObject {
    var sections = [PostDetailsViewSections]()
}

// MARK: - UITableViewDataSource
extension PostDetailsTableDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = sections[section]
        switch item {
        case .post(let array):
            return array.count
        case .comments(let array):
            return array.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .post(let rows):
            let cell = tableView.dequeueReusableCellWithRegistration(type: PostFullContentCell.self, indexPath: indexPath)
            cell.fill(with: rows[indexPath.row])
            return cell
        case .comments(let rows):
            let cell = tableView.dequeueReusableCellWithRegistration(type: PostCommentCell.self, indexPath: indexPath)
            cell.fill(with: rows[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = sections[section]
        switch item {
        case .post:
            return nil
        case .comments:
            return "Comments"
        }
    }
}
