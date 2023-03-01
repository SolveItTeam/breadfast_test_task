import Alamofire
import Foundation

enum PostsEndPoint: EndPointType {
    case getAllPosts(page: Int)
    
    var path: String {
        switch self {
        case .getAllPosts(let page):
            return "posts?page=\(page)&per_page=20"
        }
    }
    
    var method: Alamofire.HTTPMethod { .get }
    var params: Alamofire.Parameters? { nil }
}
