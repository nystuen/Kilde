import SwiftUI
import StoreKit

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isDarkModeEnabled = true
    @EnvironmentObject var router: KildeNavigationRouter
    @Environment(\.colorScheme) var colorScheme
    
    let buttonSpacing: CGFloat = 16
    
    var body: some View {
        NavigationStack(path: $router.settingsRouter.routes) {
            ScrollView {
                VStack(alignment: .leading, spacing: buttonSpacing) {
                    generalSettings
                    feedback
                    Spacer()
                    HStack {
                        Spacer()
                        Text("version: \(Bundle.main.appVersionLong), build: \(Bundle.main.appBuild)")
                            .opacity(0.1)
                        Spacer()
                    }
                    signOutButton
                }
                .padding()
            }
            .foregroundColor(.theme.text)
            .background(Color.theme.background)
            .alert(isPresented: $vm.notificationsDisabledInSettingAlertEnabled) {
                notificationsDisabledAlert
            }
            .navigationTitle("Settings")
            .navigationDestination(for: Route.self) { $0 }
        }
        .onAppear {
            vm.onAppear()
        }
    }
}

extension SettingsView {
    
    var signOutButton: some View {
        
        HStack(alignment: .center) {
            Spacer()
            Button {
                authViewModel.signOut()

            } label: {
                Text("Sign out")
            }
            .foregroundColor(.theme.darkRed)
            Spacer()
        }
    }
    
    var notificationsDisabledAlert: Alert {
        Alert(
            title: Text("Varsler er slått av"),
            message: Text("For å motta varsler, må dette aktiveres i enhetsinnstillingene."),
            primaryButton: .default(Text("Åpne Innstillinger"), action: {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }),
            secondaryButton: .cancel()
        )
    }
    
    var adminSettings: some View {
        NavigationLink(value: Route.adminView) {
            settingsButton(title: "Admin Settings", icon: "person.fill") {}
                .disabled(true)
        }
    }
    
    var selectedSources: some View {
        NavigationLink(value: Route.sourcesView) {
            settingsButton(title: "Sources", icon: "book") {}
                .disabled(true)
        }
    }
    
    var feedback: some View {
        VStack(alignment: .leading, spacing: buttonSpacing) {
            Text("Feedback")
                .font(.title2)
                .padding(.bottom, 8)
            
            settingsButton(title: "App Store", icon: "music.note.house", external: true) {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
            NavigationLink(value: Route.feedback) {
                settingsButton(title: "Kontakt oss", icon: "envelope", external: true) {}
                    .disabled(true)
            }
        }
    }
    
    var generalSettings: some View {
        VStack(spacing: buttonSpacing) {
            adminSettings
            selectedSources
//            settingsButton(title: "Account Settings", icon: "person", divider: true) {
//                print("Account")
//            }
            settingsToggleButton(title: "Notifications", icon: "bell", isOn: Binding(
                get: { vm.notificationToggle },
                set: { isSelected in
                    vm.requestNotificationPermission(enabled: isSelected)
                }
            ))
            settingsToggleButton(title: "Dark mode", icon: "moon", isOn: Binding(
                get: { colorScheme == .dark },
                set: { isSelected in
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            ))
        }
    }
    
    func settingsButton(title: String, icon: String, external: Bool = false, divider: Bool = true, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            VStack(spacing: buttonSpacing)  {
                HStack {
//                    Image(systemName: icon)
                    HStack {
                        Text(LocalizedStringKey(title))
                        Spacer()
                        if external {
                            Image(systemName: "arrow.up.right")
                        }
                    }
                }
                if divider {
                    Divider()
                }
            }
        }
    }
    
    func settingsToggleButton(title: String, icon: String, divider: Bool = true, isOn: Binding<Bool>) -> some View {
        VStack(spacing: buttonSpacing) {
            HStack {
//                Image(systemName: icon)
//                    .scaledToFill()
                Toggle(isOn: isOn) {
                    Text(LocalizedStringKey(title))
                }
            }
            if divider {
                Divider()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AuthViewModel())
            .environmentObject(KildeNavigationRouter())
    }
}
