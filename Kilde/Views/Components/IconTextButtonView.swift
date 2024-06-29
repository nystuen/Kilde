import Foundation
import SwiftUI


struct IconTextButtonView: View {
    let iconName: String
    let text: String
    
    var urlString: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            if let urlString = urlString,
               let url = URL(string: urlString),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else if let action = action {
                action()
            }
        }) {
            HStack(spacing: 10) {
                Text(text)
                if !iconName.isEmpty {
                    Image(systemName: iconName)                    
                }
            }
            .foregroundColor(.theme.accent)
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.theme.accent, lineWidth: 1)
            )
        }
    }
}

struct IconTextButtonView_Previews: PreviewProvider {
    static var previews: some View {
        IconTextButtonView(iconName: "arrow.right.circle", text: "Visit Website", urlString: "https://www.example.com")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
