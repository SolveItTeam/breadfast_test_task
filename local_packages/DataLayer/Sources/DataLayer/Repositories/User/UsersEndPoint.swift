import Foundation
import Alamofire
import DomainLayer

enum UsersEndPoint {
    case getProfile(id: UserEntity.ID)
}

extension UsersEndPoint: EndPointType {
    var method: Alamofire.HTTPMethod {
        .get
    }
    
    var params: Alamofire.Parameters? {
        nil
    }
    
    var path: String {
        switch self {
        case .getProfile(let id):
            return "users/\(id)"
        }
    }
}
