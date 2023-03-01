//
//  File.swift
//  
//
//  Created by Andrey on 01/03/2023.
//

import Foundation
import DomainLayer
import Alamofire

enum CommentsEndPoint {
    case getCommentsForPost(id: PostEntity.ID)
}

extension CommentsEndPoint: EndPointType {
    var path: String {
        switch self {
        case .getCommentsForPost(let id):
            return "posts/\(id)/comments"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        .get
    }
    
    var params: Alamofire.Parameters? {
        nil
    }
}
