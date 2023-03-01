//
//  PostsListCell.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit
import Extensions

struct PostsListCellProps: Hashable {
    let authorID: Int
    let title: String
    let content: String
    
    var localizedAuthorID: String {
        Localization.authorIDPrefix.rawValue + "\(authorID)"
    }
}

final class PostsListCell: UITableViewCell {
    // MARK: - @IBOutlet's
    @IBOutlet private weak var authorIDLabel: UILabel!
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
        authorIDLabel.text = props.localizedAuthorID
        titleLabel.text = props.title
        contentLabel.text = props.content
    }
}
