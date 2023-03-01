import Alamofire
import Foundation

enum PostsEndPoint: EndPointType {
    case getAllPosts(page: Int)
    
    var path: String {
        switch self {
        case .getAllPosts(let page):
            return "posts?page=\(page)&\(PaginationKeys.requestPath.rawValue)=\(DataLayer.itemsPerPage)"
        }
    }
    
    var method: Alamofire.HTTPMethod { .get }
    var params: Alamofire.Parameters? { nil }
}
