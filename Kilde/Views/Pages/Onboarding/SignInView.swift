import SwiftUI
import GoogleSignIn
import _AuthenticationServices_SwiftUI
import GoogleSignInSwift

struct SignInView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 32) {
                OnboardingPage(title: "Welcome to Kilde", image: "onboard", description: "Customize your news feed by selecting your preferred sources.")
                SocialLoginButton(image: Image("apple"), text: "Logg inn med Apple")
                    .overlay {
                        SignInWithAppleButton   { request in
                            viewModel.handleSignInWithAppleRequest(request)
                        } onCompletion: { result in
                            viewModel.handleSignInWithAppleCompletion(result)
                        }
                        //.signInWithAppleButtonStyle(.white)
                        .frame(height: 50)
                        .cornerRadius(70)
                        .blendMode(.overlay)
                        //.opacity(0.57)
                    }
                    .clipped()
                
                SocialLoginButton(image: Image("google"), text: "Logg inn med Google") {
                    Task {
                        try await viewModel.handleSignInWithGoogle()
                    }
                }
            }
            .padding(.horizontal, 32)
            .padding()
            .multilineTextAlignment(.center)
        }
    }
}
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

struct SocialLoginButton: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var image: Image
    var text: String
    var action: (() -> Void)?
    
    var body: some View {
        Button {
            (action ?? {})()
        } label: {
            HStack(alignment: .center) {
                Spacer()
                image
                    .padding(.horizontal)
                Text(text)
                    .foregroundColor(.black)
                    .font(.body)
                Spacer()
            }
            .padding()
            .background(colorScheme == .dark ? Color.white : Color.white)
            .frame(maxWidth: .infinity)
            .cornerRadius(50.0)
            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
        }
    }
}
