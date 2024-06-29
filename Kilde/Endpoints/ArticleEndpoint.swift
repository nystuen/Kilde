import Foundation

protocol APIEndpoint {
    var urlRequest: URLRequest { get }
    var baseUrl: URL { get }
    var path: String { get }
}

enum ArticleAPI {
    case getArticles([Source]), getSources, getArticle(String), runJobs
}

extension ArticleAPI: APIEndpoint {
    var baseUrl: URL {
        URL(string: "https://kildewebapi.azurewebsites.net/api")!
    }
    
    var path: String {
        switch self {
        case .getArticles:
            return "/article"
        case .getSources:
            return "/source"
        case .getArticle(let id):
            return "/article?id=\(id)"
        case .runJobs:
            return "/kildejobs"
        }
    }
    
    var urlRequest: URLRequest {
        URLRequest(url: self.baseUrl.appendingPathComponent(self.path))
    }
}
