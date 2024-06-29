import Foundation

enum DeepLinkURLs: String {
    case article = "article"
}

struct RouteFinder {
    
    var articleService = ArticleServiceImpl()
    
    func find(from url: URL, vm: ArticleListViewModel?) async -> Route? {
        guard let host = url.host() else { return nil }
        
        switch DeepLinkURLs(rawValue: host) {
        case .article:
            let queryParams = url.queryParameters
            guard let id = queryParams?["id"] as? String else { return nil }
            let article = articleService.request(from: ArticleAPI.getArticle(id))
            guard let vm = vm else { return nil}
            return .article(article: DeveloperPreview.dummyArticle, vm: vm)
        case .none:
            return nil
        }
    }
}

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value?.replacingOccurrences(of: "+", with: " ")
        }
    }
}
