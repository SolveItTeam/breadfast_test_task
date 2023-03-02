//
//  PostFullContentCell.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit
import Extensions

final class PostFullContentCell: UITableViewCell {
    // MARK: - @IBOutlet's
    @IBOutlet private weak var authorInfoLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

// MARK: - ConfigurableTableNibCell
extension PostFullContentCell: ConfigurableTableNibCell {
    typealias Props = PostsListCellProps
    
    func fill(with props: PostsListCellProps) {
        authorInfoLabel.text = props.fullAuthorInfo
        titleLabel.text = props.title
        contentLabel.text = props.content
    }
}
