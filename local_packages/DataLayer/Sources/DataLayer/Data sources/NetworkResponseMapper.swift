import Foundation

struct NetworkResponseMapper {
    let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = .basic) {
        self.decoder = decoder
    }
    
    func map<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        try decoder.decode(type, from: data)
    }
}
