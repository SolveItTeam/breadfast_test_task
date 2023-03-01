//
//  PostCommentCell.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit
import Extensions

struct PostCommentCellProps: Hashable {
    let authorName: String
    let content: String
}

final class PostCommentCell: UITableViewCell {
    // MARK: - @IBOutlet's
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

// MARK: - ConfigurableTableNibCell
extension PostCommentCell: ConfigurableTableNibCell {
    typealias Props = PostCommentCellProps
    
    func fill(with props: Props) {
        authorNameLabel.text = props.authorName
        contentLabel.text = props.content
    }
}
