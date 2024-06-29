import SwiftUI

struct Tab: View {
    var body: some View {
        TabView {
            ArticleListView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Nyheter")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Innstillinger")
                }
        }
    }
}

struct Tab_Previews: PreviewProvider {
    static var previews: some View {
        Tab()
    }
}
