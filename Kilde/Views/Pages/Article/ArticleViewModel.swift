import SwiftUI

class ArticleViewModel: ObservableObject {
    @Published var article: Article
    @Published var isLoading = false
    
    init(article: Article) {
        self.article = article
    }
    
    func updateArticle(newArticle: Article) {
        isLoading = true
        self.article = newArticle
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isLoading = false
        }
    }
}
