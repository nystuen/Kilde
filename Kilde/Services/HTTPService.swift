import Foundation
import Combine

class HTTPService {
    static let shared = HTTPService()
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func post<T: Decodable>(from endpoint: APIEndpoint, body: Data) -> AnyPublisher<T, APIError> {
        var urlRequest = endpoint.urlRequest
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request(from: endpoint, urlRequest: urlRequest)
    }
    
    func get<T: Decodable>(from endpoint: APIEndpoint, urlRequest: URLRequest? = nil) -> AnyPublisher<T, APIError> {
        request(from: endpoint, urlRequest: urlRequest)
    }
    
    
    private func request<T: Decodable>(from endpoint: APIEndpoint, urlRequest: URLRequest? = nil) -> AnyPublisher<T, APIError> {
        return URLSession.shared
            .dataTaskPublisher(for: (urlRequest != nil) ? urlRequest! : endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unknown }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: .unknown)
                        .eraseToAnyPublisher()
                }
                
                if (200...299).contains(response.statusCode) {
                    return Just(data)
                        .decode(type: T.self, decoder: self.jsonDecoder)
                        .mapError { _ in .decodingError }
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: .errorCode(response.statusCode))
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getWithoutResult(from endpoint: APIEndpoint) {
        URLSession.shared.dataTask(with: endpoint.urlRequest)
    }
}
