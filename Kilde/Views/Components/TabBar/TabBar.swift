import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            ArticleListViewTab()
                .tabItem {
                    Image(systemName: "book")
                        .frame(height: 80)
                    Text("Nyheter")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                        .frame(height: 80)
                    Text("Innstillinger")
                }
        }
        .tint(.theme.accent)
        .background(Color.theme.background)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor(Color.theme.background.opacity(0.4))
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
