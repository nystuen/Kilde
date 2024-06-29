import SwiftUI
import AVFoundation
import BetterSafariView

struct ArticleView: View {
    
    @State var isSpeaking = false
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var vm: ArticleListViewModel
    @EnvironmentObject var router: KildeNavigationRouter
    
    let article: Article
    let speechService = SpeechService()
        
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text(article.headline)
                        .font(.title)
                    image
                    dateAndAuthor
                    summary
                    readMoreBtn
                    
                }
                .padding()
                ScrollView(.horizontal) {
                    articleList
                }
            }
        }
        .navigationDestination(for: Route.self) { $0 }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.theme.background)
        .onAppear {
            Log.shared.event(.articleTapped(article))
            vm.articleHasBeenSeen(article: article)
        }
        .toolbar {
            Menu {
                NavigationLink {
                    FeedbackView(articleId: article.headline)
                } label: {
                    Label("Feedback", systemImage: "exclamationmark.circle")
                }
                
            } label: {
                Label("More", systemImage: "ellipsis")
                    .padding(.vertical)
            }
        }
    }
}

extension ArticleView {
    
    @ViewBuilder
    var newArticleList: some View {
        let route = article.forceWebView ? Route.webView(isForced: true, article: article, vm: vm) : Route.article(article: article, vm: vm)
        if let articles = vm.getArticlesWithAuthor(author: article.author) {
            VStack {
                Text(article.headline)
                // Other article details and content
                
                // Similar articles
                List(articles, id: \.self) { similarArticle in
                    Button {
                        router.replace(with: route)
                    } label: {
                        ArticleNewCellView(article: article, showImage: false)
                    }
                }
            }
        }
    }
    
    var readMoreBtn: some View {
        HStack(alignment:. center) {
            Spacer()
            NavigationLink {
                BrowserView(isForced: false, article: article)
                    .environmentObject(vm)
            } label: {
                Label("Les mer", systemImage: "arrow.right.circle")
                    .foregroundColor(.theme.accent)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.theme.accent, lineWidth: 1)
                    )
            }
            Spacer()
        }
        .padding(.top, 16)
    }
    
    var summary: some View {
        HStack {
            Rectangle()
                .frame(width: 2)
                .foregroundColor(.theme.accent)
            Text("TLDR ")
                .bold()
                .foregroundColor(.theme.accent)
            +
            Text(article.article)
            
        }
        .font(.body)
    }
    
    var dateAndAuthor: some View {
        HStack {
            Text(article.datePrettified)
            Spacer()
            listenButton
            Spacer()
            Text("By \(article.authorPrettified)")
        }
        .font(.subheadline)
        .foregroundColor(.theme.secondaryText)
    }
    
    @ViewBuilder
    var image: some View {
        if article.imageUrl != "" {
            HStack(alignment: .center) {
                FetchedImage(urlString: article.imageUrl)
                    .cornerRadius(10)
                    .scaledToFit()
            }
        }
    }
    
    var listenButton: some View {
        return Button {
            isSpeaking.toggle()
            speechService.speak(text: article.article, voiceType: .waveNetMale) {
                isSpeaking.toggle()
            }
        } label: {
            if isSpeaking {
                ProgressView()
            } else {
                Image(systemName: "speaker.wave.2")
            }
        }
        .disabled(isSpeaking)
        .opacity(isSpeaking ? 0.5 : 1)
    }
    
    @ViewBuilder
    var articleList: some View {
        if let articles = vm.getArticlesWithAuthor(author: article.author) {
            LazyHStack(spacing: 16) {
                ForEach(articles, id: \.self) { article in
                    articleCellView(article: article)
                }
            }
            .padding(.bottom)
        }
    }
    
    @ViewBuilder
    func articleCellView(article: Article) -> some View {
        let route = article.forceWebView ? Route.webView(isForced: true, article: article, vm: vm) : Route.article(article: article, vm: vm)
        
        Button {
            router.replace(with: route)
        } label: {
            ArticleNewCellView(article: article, showImage: false)
                .contentShape(Rectangle())
                .frame(width: UIScreen.main.bounds.width * (8/10))
        }
        /*
         NavigationLink(value: route) {
         ArticleNewCellView(article: article, showImage: false)
         .contentShape(Rectangle())
         .frame(width: UIScreen.main.bounds.width * (8/10))
         }
         .buttonStyle(PlainButtonStyle())
         */
    }
}


struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleView(article: DeveloperPreview.dummyArticle)
                .environmentObject(ArticleListViewModel(articleService: ArticleServiceImpl()))
        }
    }
}
