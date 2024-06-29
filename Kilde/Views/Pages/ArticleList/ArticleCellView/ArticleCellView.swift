import SwiftUI

struct ArticleCellView: View {
    @State var article: Article
    @State var isLoading: Bool = false
    
    var headline: some View {
        Text(article.headline)
            .font(.title3)
    }
    
    var dateAndAuthor: some View {
        HStack {
            Text(article.datePrettified)
            Spacer()
            Text(article.authorPrettified)
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            headline
            dateAndAuthor
            if !article.imageUrl.isEmpty {
                FetchedImage(urlString: article.imageUrl)
                    .cornerRadius(10)
                    .frame(minHeight: 125)
                    .scaledToFit()
            }
        }
        .padding()
        .redacted(reason: isLoading ? .placeholder : [])
        .allowsHitTesting(!isLoading)
    }
    
    func getAuthor(name: String) -> String {
        return name.split(separator: " ").first?.lowercased() ?? ""
    }
}

extension ArticleCellView {
    init(skeleton: Bool) {
        self.init(article: DeveloperPreview.dummyArticle, isLoading: true)
    }
}

struct ArticleCellView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleCellView(article: DeveloperPreview.dummyArticle)
    }
}
