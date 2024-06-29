import SwiftUI
import WebKit

struct BrowserView: View {
    @State private var webView: WKWebView?
    @State private var showErrorDialog = false
    @EnvironmentObject var vm: ArticleListViewModel
    
    let article: Article
    let initialURL: URL
    let isForced: Bool
    
    init(isForced: Bool, article: Article) {
        self.initialURL = URL(string: article.authorUrl)!
        self.isForced = isForced
        self.article = article
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                VStack {
                    if isForced, showErrorDialog {
                        Text("Kunne ikke hente sammendrag")
                            .font(.callout)
                            .opacity(0.85)
                    }
                    WebViewWrapper(webView: $webView, url: initialURL)
                        .navigationBarHidden(true)
                }
            }
        }
        .toolbar {
            Button(action: {
                UIApplication.shared.open(initialURL)
            }) {
                Label("Feedback", systemImage: "safari.fill")
                    .foregroundColor(.theme.accent)
            }
        }
        .onAppear {
            let wkwebView = WKWebView()
            let request = URLRequest(url: initialURL)
            wkwebView.load(request)
            webView = wkwebView
            vm.articleHasBeenSeen(article: article)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showErrorDialog = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    showErrorDialog = false
                }
            }
        }
    }
}

struct WebViewWrapper: UIViewRepresentable {
    @Binding var webView: WKWebView?
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if webView != nil {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewWrapper
        
        var hasLoaded = false
        
        init(_ parent: WebViewWrapper) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(hasLoaded ? .cancel : .allow)
            hasLoaded = true
            // TODO: Give info to user that redirection is blocked
        }
    }
}

struct BrowserView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserView(isForced: true, article: DeveloperPreview.dummyArticle)
    }
}
