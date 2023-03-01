import Foundation
import Combine
import Alamofire

public enum APIDataSourceError: Error {
    case cantDecodeResponse
    case somethingWrong
}

final class APIDataSource {
    private let token: String
    private let baseURL: URL
    private let mapper: NetworkResponseMapper
    private let session: Session
    private let mappingQueue: DispatchQueue
    
    // MARK: - Initialization
    init(
        token: String,
        baseURL: URL,
        mapper: NetworkResponseMapper,
        mappingQueue: DispatchQueue
    ) {
        self.token = token
        self.baseURL = baseURL
        self.mapper = mapper
        self.mappingQueue = mappingQueue
        self.session = .default
    }
    
    // MARK: - Logic
    func send<Response: Decodable>(_ response: Response.Type, endpoint: EndPointType) -> AnyPublisher<Response, Error>  {
        Future<Response, Error> { [weak self] closure in
            guard let self = self else { return }
            
            let factory = RequestFactory(
                baseURL: self.baseURL,
                session: self.session,
                token: self.token
            )
            let request = factory.makeData(endpoint)
            request.response(queue: self.mappingQueue) { afResponse in
                switch afResponse.result {
                case .success(let data):
                    guard let responseData = data else {
                        closure(.failure(APIDataSourceError.cantDecodeResponse))
                        debugPrint("empty response data, for path = \(endpoint.path)")
                        return
                    }
                    do {
                        let response = try self.mapper.map(response, from: responseData)
                        closure(.success(response))
                    } catch let error {
                        closure(.failure(APIDataSourceError.cantDecodeResponse))
                        debugPrint("cant decode error = \(error.localizedDescription), for path = \(endpoint.path)")
                    }
                case .failure(let error):
                    debugPrint("send request error = \(error.localizedDescription), for path = \(endpoint.path)")
                    closure(.failure(APIDataSourceError.somethingWrong))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Factory
private struct RequestFactory {
    let baseURL: URL
    let session: Session
    let token: String
    
    private enum Keys: String {
        case apiKey = "Bearer "
    }
    
    private func makeHeaders(_ endpoint: EndPointType) -> Alamofire.HTTPHeaders {
        var headers = endpoint.baseHeaders
        endpoint.customHeaders?.forEach({ headers.add($0) })
        headers.add(.authorization(Keys.apiKey.rawValue + token))
        return headers
    }
    
    func makeFullPath(_ endpoint: EndPointType) -> String {
        baseURL.absoluteString + "/" + endpoint.path
    }
    
    func makeData(_ endpoint: EndPointType) -> DataRequest {
        session.request(
            makeFullPath(endpoint),
            method: endpoint.method,
            parameters: endpoint.params,
            encoding: endpoint.paramsEncoding,
            headers: makeHeaders(endpoint)
        )
    }
}
