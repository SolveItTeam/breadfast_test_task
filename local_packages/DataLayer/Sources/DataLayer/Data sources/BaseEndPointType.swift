import Foundation
import Alamofire

/// Basic description of REST endpoint
protocol EndPointType {
    var path: String { get }
    var customHeaders: Alamofire.HTTPHeaders? { get }
    var method: Alamofire.HTTPMethod { get }
    var baseHeaders: Alamofire.HTTPHeaders { get }
    var params: Alamofire.Parameters? { get }
    var paramsEncoding: Alamofire.ParameterEncoding { get }
}

extension EndPointType {
    var customHeaders: Alamofire.HTTPHeaders? { return nil }
    var baseHeaders: Alamofire.HTTPHeaders { .default }
    var paramsEncoding: Alamofire.ParameterEncoding { JSONEncoding.default }
}

