import Foundation
import SwiftUI

struct PromoData {
    let desc: String
    let pct: Decimal?
}

enum Route {
    case article(article: Article, vm: ArticleListViewModel), sourcesView, adminView, feedback, webView(isForced: Bool, article: Article, vm: ArticleListViewModel)
}

extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs) {
        case (.article(let lhsArticle, _), .article(let rhsArticle, _)):
            return lhsArticle.headline == rhsArticle.headline
        default:
            return false
        }
    }
}

extension Route: View {
    var body: some View {
        switch self {
        case .article(let article, let vm):
            ArticleView(article: article)
                .environmentObject(vm)
        case .sourcesView:
            SourcesView()
        case .adminView:
            AdminView()
        case .feedback:
            FeedbackView()
        case .webView(let isForced, let article, let vm):
            BrowserView(isForced: isForced, article: article)
                .environmentObject(vm)
        }
    }
}

// Deep link to specific article
extension Route {
    /*
     static func buildDeepLink(from route: Route) -> URL? {
     switch route {
     case .article(let item):
     
     let queryProductItem = item.title.replacingOccurrences(of: " ", with: "+")
     let queryProductId = "\(item.name)_\(queryProductItem)"
     
     var url = URL(string: "kilde://product")!
     let queryItems = [URLQueryItem(name: "item", value: queryProductId)]
     
     url.append(queryItems: queryItems)
     
     return url
     default:
     break
     }
     
     return nil
     }
     */
}
