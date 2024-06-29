import Foundation
import Combine

protocol ArticleService {
    var articles: [Article] { get }
    var selectedSources: [Source] { get }
    
    func postRequest(to endpoint: APIEndpoint, from sources: [Source]) -> AnyPublisher<[Article], APIError>
    func request(from endpoint: APIEndpoint) -> AnyPublisher<[Article], APIError>
}

class ArticleServiceImpl: ArticleService {
    @Published var articles: [Article] = []
    @Published var selectedSources: [Source] = []
    private let sourceService = SourceService.shared
    private var cancellables: Set<AnyCancellable> = []

    static let shared = ArticleServiceImpl()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        sourceService.$selectedSources
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { [weak self] selectedSources in
                guard let self = self else { return }
                self.selectedSources = selectedSources
            }
            .store(in: &cancellables)
    }
    
    func postRequest(to endpoint: APIEndpoint, from sources: [Source]) -> AnyPublisher<[Article], APIError> {
        let jsonEncoder = JSONEncoder()
        guard let sourcesData = try? jsonEncoder.encode(sources.map { $0.name }) else {
            return Fail(error: APIError.decodingError)
                .mapError { _ in .decodingError }
                .eraseToAnyPublisher()
        }

        return HTTPService.shared.post(from: endpoint, body: sourcesData)
    }

    func request(from endpoint: APIEndpoint) -> AnyPublisher<[Article], APIError> {
        return HTTPService.shared.get(from: endpoint)
    }
}
