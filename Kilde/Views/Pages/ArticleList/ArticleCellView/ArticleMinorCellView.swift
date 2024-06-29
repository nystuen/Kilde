import SwiftUI

struct ArticleMinorCellView: View {
    @State var article: Article
    @State var isLoading: Bool = false
    let showImage: Bool = true
        
    var body: some View {
        HStack {
            if showImage {
                FetchedImage(urlString: article.imageUrl)
                    .scaledToFit()
                    .cornerRadius(10)
                #if os(iOS)
                    .frame(width: UIScreen.main.bounds.width * (1/3))
                #endif
                    .opacity(article.seen ? 0.35 : 1)
            }
            VStack(alignment: .leading) {
                Text(article.headline)
                    .font(.subheadline)
                HStack {
                    Text(article.datePrettified)
                    Spacer()
                    Text(article.authorPrettified)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
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

extension ArticleMinorCellView {
    init(skeleton: Bool) {
        self.init(article: DeveloperPreview.dummyArticle, isLoading: true)
    }
}


struct ArticleMinorCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        ArticleMinorCellView(article: DeveloperPreview.dummyArticle)
    }
}
