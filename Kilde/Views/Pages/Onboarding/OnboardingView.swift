import SwiftUI

struct OnboardingView: View {
    @State private var currentPage: Int = 0
    @State var hasSeenOnboarding = false
    
    var body: some View {
        if hasSeenOnboarding {
            TabBar()
        } else {
            onboardingView {
                self.hasSeenOnboarding = true
                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasSeenOnboarding.key)

            }
        }
    }
}

extension OnboardingView {
    func onboardingView(action: @escaping () -> Void) -> some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $currentPage) {
                OnboardingPage(title: "Welcome to Kilde", imageName: "newspaper.fill", description: "Customize your news feed by selecting your preferred sources.")

                    .tag(0)
                
                OnboardingPage(title: "Customize your news", imageName: "pencil", description: "Discover the freshest news gathered in one place!")
                    .tag(1)
                
                OnboardingPage(title: "Choose your own sources", description: "Choose the news sources that matter most to you.", buttonTitle: "Go to the front page 🎉", action: action)
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
        .background(Color.theme.background)
    }
    
    var floatingActionButton: some View {
        ZStack {
            Circle()
                .foregroundColor(.theme.accent) // Button background color
                .frame(width: 60, height: 60) // Button size
                .shadow(radius: 5) // Add a shadow for a floating effect
            
            Image(systemName: "arrow.right") // Arrow icon
                .font(.system(size: 25))
                .foregroundColor(.white) // Icon color
                .opacity(1)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
