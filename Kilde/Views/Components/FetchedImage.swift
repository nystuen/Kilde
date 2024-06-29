import Foundation
import SwiftUI

struct FetchedImage: View {
    var url: URL?
    @State var isLoading = true
    
    init(urlString: String) {
        if let url = URL(string: urlString) {
            self.url = url
        }
    }
    
    var body: some View {
        CachedAsyncImage(url: url, urlCache: .imageCache) { image in
                image
                    .resizable()
                    //.scaledToFit()
        } placeholder: {
            Rectangle()
                .redacted(reason: .placeholder)
                .opacity(0.2)
        }
    }
}

struct FetchedImage_Previews: PreviewProvider {
    static var previews: some View {
        FetchedImage(urlString: "htftps://akamai.vgc.no/v2/images/ce7f7bfe-86a2-4f84-92e6-01b82e2e97c0?fit=crop&format=auto&h=533&w=800&s=534c12f430e20dd3e1dc5ad0afc5799134a088e9")
    }
}
