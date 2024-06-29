import Foundation
import Combine

enum ResultState {
    case loading
    case failed(error: APIError)
    case success
}

struct ArticleSection: Hashable {
    let title: String
    var articles: [Article]
    var isHidden: Bool
}

class ArticleListViewModel: ObservableObject {
    @Published var firstArticle: Article?
    @Published var articles = [Article]()
    @Published var articlesFromSource: [String:[Article]] = [:]
    @Published var articleSections = [ArticleSection]()
    
    @Published var state: ResultState = .loading
    @Published var articleDisplayMode: ArticleDisplayMode = .big
    @Published var listDisplayMode: ListDisplayMode = .sections
    
    private var seenArticles = UserDefaults.standard.array(forKey: UserDefaultsKeys.seenArticles.key) as? [String] ?? []
    private var articleService: ArticleServiceImpl
    private var cancellables: Set<AnyCancellable> = []
    
    init(articleService: ArticleServiceImpl) {
        self.articleService = articleService
        self.articleService.$selectedSources
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.state = .loading
                self?.fetchArticles()
            }
            .store(in: &cancellables)
        self.setupArticleDisplayMode()
        self.setupListDisplayMode()
    }
    
    private func setupArticleDisplayMode() {
        if let displayModeString = UserDefaults.standard.string(forKey: UserDefaultsKeys.articleDisplayMode.key),
           let displayMode = ArticleDisplayMode(rawValue: displayModeString) {
            articleDisplayMode = displayMode
        }
        $articleDisplayMode
            .receive(on: DispatchQueue.main)
            .sink { articleDisplayMode in
                UserDefaults.standard.set(articleDisplayMode.rawValue, forKey: UserDefaultsKeys.articleDisplayMode.key)
            }
            .store(in: &cancellables)
        
    }
    
    private func setupListDisplayMode() {
        if let listDisplayModeString = UserDefaults.standard.string(forKey: UserDefaultsKeys.listDisplayMode.key),
           let displayMode = ListDisplayMode(rawValue: listDisplayModeString) {
            listDisplayMode = displayMode
        }
        $listDisplayMode
            .receive(on: DispatchQueue.main)
            .sink { listDisplayMode in
                UserDefaults.standard.set(listDisplayMode.rawValue, forKey: UserDefaultsKeys.listDisplayMode.key)
            }
            .store(in: &cancellables)
        
    }
    
    func fetchArticles() {
        articleService.postRequest(to: ArticleAPI.getArticles([]), from: articleService.selectedSources)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("ERROR:", error)
                    self.state = .failed(error: error)
                }
            }) { [weak self] fetchedArticles in
                guard let self = self else { return }
                articles = fetchedArticles.sorted(by: { lhs, rhs in
                    lhs.date > rhs.date
                })
                refreshSeenArticles()
                articleSections = createArticleSectionsFromDict(articles)
                state = .success
            }
            .store(in: &cancellables)
    }
    
    func createArticleSectionsFromDict(_ articles: [Article]) -> [ArticleSection] {
        var sections = [ArticleSection]()
        let dict = createArticlesFromSource(articles)
        sections = dict.map { ArticleSection(title: $0, articles: $1, isHidden: false) }
        return sections.sorted { ($0.articles.first?.date ?? Date.now ) > ($1.articles.first?.date ?? Date.now) }
    }
    
    func createArticlesFromSource(_ articles: [Article]) -> [String: [Article]] {
        var articlesFromSource: [String: [Article]] = [:]
        
        for article in articles {
            if let existingArticles = articlesFromSource[article.author] {
                articlesFromSource[ article.author] = existingArticles + [article]
            } else {
                articlesFromSource[ article.author] = [article]
            }
        }
        
        return articlesFromSource
    }
    
    private func refreshSeenArticles() {
        // TODO: Update to use ID instead of headline
        seenArticles = UserDefaults.standard.array(forKey: UserDefaultsKeys.seenArticles.key) as? [String] ?? []
        for index in articles.indices {
            if seenArticles.contains(articles[index].headline) {
                    self.articles[index].seen = true
            }
        }
    }
    
    func articleHasBeenSeen(article: Article) {
        // TODO: Update to use ID instead of headline
        if !seenArticles.contains(article.headline) {
            seenArticles.append(article.headline)
            UserDefaults.standard.set(seenArticles, forKey: UserDefaultsKeys.seenArticles.key)
            markArticleAsSeen(article)
        }
    }
    
    private func markArticleAsSeen(_ article: Article) {
        // TODO: Update to use ID instead of headline
        for index in 0..<self.articleSections.count {
            if let articleIndex = self.articleSections[index].articles.firstIndex(where: { $0.headline == article.headline }) {
                articleSections[index].articles[articleIndex].seen = true
                break
            }
        }
    }
    
    func getArticlesWithAuthor(author: String) -> [Article]? {
        return articleSections.filter({ $0.title.lowercased() == author.lowercased() }).first?.articles
    }
}
