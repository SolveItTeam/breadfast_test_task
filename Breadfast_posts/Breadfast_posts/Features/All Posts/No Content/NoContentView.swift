//
//  NoContentView.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit
import Extensions

final class NoContentView: UIView {
    @IBOutlet
    private weak var imageView: UIImageView! {
        didSet {
            imageView.image = Images.noContent.value
        }
    }
    
    @IBOutlet
    private weak var textLabel: UILabel! {
        didSet {
            textLabel.text = Localization.noPosts.rawValue
        }
    }
    
    // MARK: - Initilization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupXib()
    }
}

