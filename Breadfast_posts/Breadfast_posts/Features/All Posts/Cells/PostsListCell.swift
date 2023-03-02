//
//  PostsListCell.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit
import Extensions

struct PostsListCellProps: Hashable {
    let authorName: String?
    let authorEmail: String?
    let title: String
    let content: String
    let fullAuthorInfo: String
    
    init(authorName: String?, authorEmail: String?, title: String, content: String) {
        self.authorName = authorName
        self.authorEmail = authorEmail
        self.title = title
        self.content = content
        
        var fullInfo = ""
        if let authorName = authorName {
            fullInfo += authorName
        }
        if let authorEmail = authorEmail {
            fullInfo += " | \(authorEmail)"
        }
        
        self.fullAuthorInfo = fullInfo
    }
}

final class PostsListCell: UITableViewCell {
    // MARK: - @IBOutlet's
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

// MARK: - ConfigurableTableNibCell
extension PostsListCell: ConfigurableTableNibCell {
    typealias Props = PostsListCellProps
    
    func fill(with props: PostsListCellProps) {
        authorLabel.text = props.fullAuthorInfo
        titleLabel.text = props.title
        contentLabel.text = props.content
    }
}
