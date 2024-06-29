import SwiftUI
import FirebaseAuth

struct KildeSplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.3
    @State private var opacity = 0.0
    @State private var offset = CGFloat(0)
    @State private var hasSeenOnboarding = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var user = Auth.auth().currentUser
    
    var body: some View {
        ZStack {
            if isActive {
                if authViewModel.userSession == nil {
                    SignInView()
                } else {
                    TabBar()
                }
            } else {
                splashScreenView
            }
        }
    }
}

extension KildeSplashScreenView {
    var splashScreenView: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                Text("Kilde")
            }
            .foregroundColor(.theme.text)
            .font(.system(size: 90))
            .scaleEffect(size)
            .opacity(opacity)
            .offset(x: offset ,y: -offset)
            .onAppear {
                withAnimation(.easeIn(duration: 1.5)) {
                    self.size = 0.7
                    self.opacity = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                        withAnimation(.easeIn(duration: 0.15)) {
                            self.opacity = 0
                            self.size = 0.3
                        }
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                self.isActive = true
            }
        }
    }
}

struct KildeSplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        KildeSplashScreenView()
            .environmentObject(KildeNavigationRouter())
            .environmentObject(AuthViewModel())
    }
}
