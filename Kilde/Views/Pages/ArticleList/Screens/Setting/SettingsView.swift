import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    let websites: [NewsWebsite] = NewsWebsite.allCases
    
    var body: some View {
        Form {
            Section(header: Text("Hvor vil du se nyheter fra?")) {
                List(websites, id: \.self) { website in
                    Toggle(isOn: Binding(
                        get: { viewModel.selectedWebsites.contains(website) },
                        set: { isSelected in
                            viewModel.updateWebsite(website: website, enabled: isSelected)
                        }
                    )) {
                        Text(website.displayName)
                    }
                }
            }
        }
        .navigationBarTitle("Innstillinger")
        .onAppear {
            viewModel.loadSelectedWebsites()
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
