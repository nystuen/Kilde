import SwiftUI

struct ArticleNewCellView: View {
    @State var article: Article
    @State var isLoading: Bool = false
    
    let showImage: Bool
    
    var shouldShowImage: Bool {
        showImage && !article.imageUrl.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                headline
                dateAndAuthor
            }
            .padding(.horizontal)
            .padding(shouldShowImage ? .top : .vertical)
            if shouldShowImage {
                FetchedImage(urlString: article.imageUrl)
                    .scaledToFill()
                    .frame(maxHeight: 200)
                    .clipped()
                    .opacity(article.seen ? 0.35 : 1)
            }
        }
        .background(Color.theme.cell)
        .cornerRadius(16)
        .redacted(reason: isLoading ? .placeholder : [])
        .allowsHitTesting(!isLoading)
    }
    
    func getAuthor(name: String) -> String {
        return name.split(separator: " ").first?.lowercased() ?? ""
    }
}

extension ArticleNewCellView {
    init(skeleton: Bool) {
        self.init(article: DeveloperPreview.dummyArticle, isLoading: true, showImage: true)
    }
    
    var headline: some View {
        Text(article.headline)
            .font(.headline)
    }
    
    var dateAndAuthor: some View {
        HStack {
            Text(article.datePrettified)
            Spacer()
            Text(article.authorPrettified)
        }
        .font(.subheadline)
        .foregroundColor(.primary)
    }
    
}

struct ArticleNewCellView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            ArticleNewCellView(article: DeveloperPreview.dummyArticle, showImage: true)
                .padding(.horizontal)
        }
    }
}
