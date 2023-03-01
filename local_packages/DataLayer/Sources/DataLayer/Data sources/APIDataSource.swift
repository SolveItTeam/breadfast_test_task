import Foundation
import Combine
import Alamofire
import DomainLayer

public struct APIDataSourceError: Error {
    public let code: NetworkCodes
    public let description: String?
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
    func send<Response: Decodable>(
        _ response: Response.Type,
        endpoint: EndPointType
    ) -> AnyPublisher<(data: Response, pagination: PaginationStateEntity?), Error>  {
        Future<(data: Response, pagination: PaginationStateEntity?), Error> { [weak self] closure in
            guard let self = self else { return }
            
            let factory = RequestFactory(
                baseURL: self.baseURL,
                session: self.session,
                token: self.token
            )
            let request = factory.makeData(endpoint)
            request.response(queue: self.mappingQueue) { afResponse in
                guard
                    let requestResponse = afResponse.response,
                    let code = NetworkCodes(rawValue: requestResponse.statusCode)
                else {
                    let error = APIDataSourceError(code: .serverError, description: nil)
                    closure(.failure(error))
                    return
                }
                
                switch afResponse.result {
                case .success(let data):
                    guard let responseData = data else {
                        let error = APIDataSourceError(code: code, description: nil)
                        closure(.failure(error))
                        return
                    }
                    do {
                        let responseObject = try self.mapper.map(response, from: responseData)
                        let pagination = self.makePaginationEntity(from: requestResponse)
                        let result = (responseObject, pagination)
                        closure(.success(result))
                    } catch let error {
                        let error = APIDataSourceError(code: code, description: error.localizedDescription)
                        closure(.failure(error))
                    }
                case .failure(let error):
                    let error = APIDataSourceError(code: code, description: error.errorDescription)
                    closure(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func makePaginationEntity(from response: HTTPURLResponse) -> PaginationStateEntity? {
        guard
            let currentPageString = response.value(forHTTPHeaderField: "x-pagination-page"),
            let currentPage = Int(currentPageString),
            let totalPagesString = response.value(forHTTPHeaderField: "x-pagination-pages"),
            let totalPages = Int(totalPagesString)
        else {
            return nil
        }
        return .init(currentPage: currentPage, totalPages: totalPages)
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
