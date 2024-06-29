import SwiftUI

struct OnboardingPage: View {
    let title: String
    var imageName: String? = nil
    var image: String? = nil
    let description: String
    var buttonTitle: String? = nil
    var action: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            if let imageName = imageName {
                Image(systemName: imageName)
                    .font(.system(size: 100))
                    .foregroundColor(.theme.accent)
                    .padding(.bottom, 20)
            }
            
            if let image = image {
                Image(image)
                    .font(.system(size: 100))
                    .foregroundColor(.theme.accent)
                    .padding(.bottom, 20)
            }
            
            Text(LocalizedStringKey(title))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.theme.text)
            
            Text(LocalizedStringKey(description))
                .font(.body)
                .foregroundColor(.theme.secondaryText)
                .padding(.horizontal, 20)
            
            if let buttonTitle = buttonTitle, let action = action {
                SourcesView()
                withAnimation {
                    VStack {
                        Spacer()
                        KildeButtonView(text: buttonTitle, color: .theme.accent, action: action)
                            .padding()
                        Spacer()
                    }
                }
            }
        }
        .multilineTextAlignment(.center)
        .background(Color.theme.background)
        .padding()
    }
}
struct OnboardingPage_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPage(title: "Title", imageName: "info", description: "This is a description and it is longer than normal", buttonTitle: "You're done 🎉") {
            print("Wow!")
        }
    }
}
