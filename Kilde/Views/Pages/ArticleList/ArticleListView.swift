import SwiftUI

struct ArticleListView: View {
    @ObservedObject var vm = ArticleListViewModel(articleService: ArticleServiceImpl.shared)
    @State private var isBottomSheetPresented = false
    @State var isSourcesSheetPresented: Bool = false
    @State private var scrollToTop = false
    @EnvironmentObject var router: KildeNavigationRouter
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack(path: $router.newsRouter.routes) {
            ZStack {
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
                        scrollView(VStack(spacing: 16) {
                            NavBar() {
                                isBottomSheetPresented.toggle()
                            }
                            Divider()
                                .opacity(0.7)
                            articlesList
                        })
                    }
                }
            }
            .navigationDestination(for: Route.self) { $0 }
            .onAppear {
                isSourcesSheetPresented = !UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasSetSources.key)
            }
        }
        .presentationDragIndicator(.visible)
        .sheet(isPresented: $isBottomSheetPresented) {
            DisplaySettingsView(articleMode: $vm.articleDisplayMode)
                .presentationDetents([.fraction(0.25) , .medium])
        }
        .sheet(isPresented: $isSourcesSheetPresented) {
            sourcesView
        }
    }
}

extension ArticleListView {
    
    @ViewBuilder
    var articlesList: some View {
        switch vm.listDisplayMode {
        case .sections:
            articleListSectioned($vm.articleSections)
        case .normal:
            articleList(vm.articles)
        }
    }
    
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
        VStack {
            ArticleCellView(skeleton: true)
            ForEach(0..<6) { _ in
                ArticleMinorCellView(skeleton: true)
            }
        }
    }
    
    @ViewBuilder
    func firstArticle(_ article: Article?) -> some View {
        if let firstArticle = article {
            VStack {
                NavigationLink(value: Route.article(article: firstArticle, vm: vm)) {
                    ArticleCellView(article: firstArticle)
                }
                .buttonStyle(PlainButtonStyle())
            }
        } else {
            EmptyView()
        }
    }
    
    func articleList(_ articles: [Article]) -> some View {
        LazyVStack {
            ForEach(articles, id: \.self) { article in
                ZStack {
                    articleCellView(article: article)
                }
                Divider()
                    .opacity(0.7)
            }
        }
    }
    @ViewBuilder
    func articleCellView(article: Article) -> some View {
        NavigationLink(value: Route.article(article: article, vm: vm)) {
                ZStack {
                    
                    switch vm.articleDisplayMode {
                    case .big:
                        ArticleCellView(article: article)
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
    @ViewBuilder
    func articleListSectioned(_ sections: Binding<[ArticleSection]>) -> some View {
        LazyVStack(spacing: 16) {
            ForEach(sections.indices, id: \.self) { index in
                let section = sections[index]
                Button {
                    sections[index].wrappedValue.isHidden.toggle()
                } label: {
                    HStack {
                        ZStack {
                            Text(section.wrappedValue.title)
                                .font(.body)
                        }
                        Spacer()
                        Image(systemName: section.wrappedValue.isHidden ? "chevron.up" : "chevron.down")
                            .font(.body)
                    }
                    .opacity(0.85)
                    .foregroundColor(.theme.text)
                }
                .padding(.horizontal)
                if !section.wrappedValue.isHidden {
                    ZStack {
                        articleList(section.wrappedValue.articles)
                    }
                } else {
                    Divider()
                        .opacity(0.7)
                }
                
            }
        }
    }
    
    func articleGrid(_ articles: [Article]) -> some View {
        LazyVGrid(columns: columns, alignment: .center){
            ForEach(articles, id: \.self) { article in
                ZStack {
                    NavigationLink(value: Route.article(article: article, vm: vm)) {
                        ArticleCellView(article: article)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleListView()
                .environmentObject(KildeNavigationRouter())
        }
    }
}

