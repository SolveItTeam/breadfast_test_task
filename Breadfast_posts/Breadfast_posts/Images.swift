//
//  Images.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import UIKit

enum Images: String {
    case noContent = "list.bullet.rectangle.portrait"
    
    var value: UIImage? {
        .init(systemName: self.rawValue)
    }
}
