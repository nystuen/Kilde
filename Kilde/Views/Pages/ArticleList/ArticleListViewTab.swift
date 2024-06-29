import SwiftUI

struct ArticleListViewTab: View {
    @ObservedObject var vm = ArticleListViewModel(articleService: ArticleServiceImpl.shared)
    @EnvironmentObject var router: KildeNavigationRouter
    @State private var isBottomSheetPresented = false
    @State private var isSourcesSheetPresented: Bool = false
    @State private var scrollToTop = false
    @State private var index = 0
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack(path: $router.newsRouter.routes) {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                switch vm.state {
                case .loading:
                    scrollView(skeletonList)
                case .failed(let error):
                    ErrorView(error: error) {
                        self.vm.fetchArticles()
                    }
                case .success:
                    if vm.articles.isEmpty {
                        noArticlesView
                    } else {
                        VStack(spacing: 8) {
                            NavBar() {
                                isBottomSheetPresented.toggle()
                            }
                            Divider()
                                .opacity(0.7)
                            VStack {
                                TabBarView(index: $index, sections: $vm.articleSections)
                                    .padding(.top, 4)
                                TabView(selection: $index) {
                                    ForEach (0..<vm.articleSections.count,  id: \.self) { pageId in
                                        scrollView(VStack(spacing: 16) {
                                            articleList(vm.articleSections[pageId].articles)
                                        })
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: Route.self) { $0 }
            .onAppear {
                isSourcesSheetPresented = !UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasSetSources.key)
            }
        }
        .sheet(isPresented: $isBottomSheetPresented) {
            DisplaySettingsView(articleMode: $vm.articleDisplayMode)
                .presentationDetents([.fraction(0.80)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isSourcesSheetPresented) {
            sourcesView
                .presentationDragIndicator(.visible)
        }
    }
}

extension ArticleListViewTab {
    var sourcesView: some View {
        VStack {
            Text("Plese select your initial sources.")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.theme.text)
            Text("These can be changed at any time in your settings")
                .font(.body)
                .foregroundColor(.theme.secondaryText)
                .padding(.horizontal, 20)
            SourcesView()
            Spacer()
            KildeButtonView(text: "Gå til foriden", color: .theme.accent) {
                isSourcesSheetPresented = false
            }
            .padding()
        }
        .padding()
        .background(Color.theme.background)
        .multilineTextAlignment(.center)
        .presentationDetents([.fraction(0.9)])
        .presentationDragIndicator(.visible)
        .onDisappear {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasSetSources.key)
        }
    }
    
    var noArticlesView: some View {
        VStack(alignment: .center) {
            NoArticlesView()
        }
    }
    
    func scrollView(_ view: some View) -> some View {
        return ScrollViewWithFAB { view }
            .background(Color.theme.background)
            .refreshable {
                vm.fetchArticles()
            }
    }
    
    var skeletonList: some View {
        VStack(spacing: 8) {
            NavBar() {
                isBottomSheetPresented.toggle()
            }
            
            Divider()
                .opacity(0.7)
            VStack {
                TabBarView(index: $index, sections: $vm.articleSections)
                    .padding(.top, 4)
                    
                ForEach(0..<6) { _ in
                    switch vm.articleDisplayMode {
                    case .normal:
                        ArticleMinorCellView(skeleton: true)
                    default:
                        ArticleNewCellView(skeleton: true)
                            .padding()
                    }
                }
            }
        }
    }
    
    func articleList(_ articles: [Article]) -> some View {
        LazyVStack(spacing: 16) {
            ForEach(articles, id: \.self) { article in
                ZStack {
                    articleCellView(article: article)
                        //.opacity(article.seen ? 0.5 : 1)
                }
                if vm.articleDisplayMode != .big {
                    Divider()
                        .opacity(0.7)
                }
            }
        }
    }
    
    @ViewBuilder
    func articleCellView(article: Article) -> some View {
        let route = article.forceWebView ? Route.webView(isForced: true, article: article, vm: vm) : Route.article(article: article, vm: vm)
        NavigationLink(value: route) {
            ZStack {
                switch vm.articleDisplayMode {
                case .big:
                    ArticleNewCellView(article: article, showImage: true)
                        .padding(.horizontal)
                    //ArticleCellView(article: article)
                case .normal:
                    ArticleMinorCellView(article: article)
                case .compact:
                    ArticleMinorCellView(article: article)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ArticleListViewTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleListViewTab()
                .environmentObject(KildeNavigationRouter())
        }
    }
}
