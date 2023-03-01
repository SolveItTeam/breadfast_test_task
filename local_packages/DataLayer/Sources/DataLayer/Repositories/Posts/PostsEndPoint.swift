import Alamofire
import Foundation

enum PostsEndPoint: EndPointType {
    case getAllPosts
    
    var path: String {
        switch self {
        case .getAllPosts:
            return "posts"
        }
    }
    
    var method: Alamofire.HTTPMethod { .get }
    var params: Alamofire.Parameters? { nil }
}
