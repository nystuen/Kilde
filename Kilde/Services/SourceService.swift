import Foundation
import Combine

class SourceService: ObservableObject {
    @Published var selectedSources: [Source] = []
    static let shared = SourceService()
    
    init() {
        loadSelectedSources()
    }
    
    func updateSource(source: Source, enabled: Bool) {
        var selectedSourceIds = selectedSources.map { $0.name }
        if enabled, !selectedSourceIds.contains(source.name) {
            selectedSourceIds.append(source.name)
        } else {
            selectedSourceIds = selectedSourceIds.filter { $0 != source.name }
        }
        UserDefaults.standard.set(selectedSourceIds, forKey: UserDefaultsKeys.selectedSources.key)
        loadSelectedSources()
        #if os(iOS)
        Log.shared.event(.sourcesUpdated(selectedSourceIds))
        #endif
    }
    
    func saveSelectedSources() {
        let selectedSourceIds = selectedSources.map { $0.name }
        UserDefaults.standard.set(selectedSourceIds, forKey: UserDefaultsKeys.selectedSources.key)

    }
    
    func fetchSources() -> AnyPublisher<[Source], APIError> {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared
            .dataTaskPublisher(for: ArticleAPI.getSources.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unknown }
            .flatMap { data, response -> AnyPublisher<[Source], APIError> in

                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: .unknown)
                            .eraseToAnyPublisher()
                }

                if (200...299).contains(response.statusCode) {
                    return Just(data)
                        .decode(type: [Source].self, decoder: jsonDecoder)
                        .mapError {_ in .decodingError}
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: .errorCode(response.statusCode))
                            .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    func loadSelectedSources() {
        guard let selectedSourceIds = UserDefaults.standard.array(forKey: UserDefaultsKeys.selectedSources.key) as? [String] else {
            selectedSources = []
            return
        }
        
        let sources = selectedSourceIds.compactMap { Source(name: $0, link: "")}
        selectedSources = sources
    }
}
