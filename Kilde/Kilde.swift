import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    var app: KildeApp?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        NotificationService.shared.scheduleNotification()
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        if let deepLink = response.notification.request.content.userInfo["link"] as? String,
           let url = URL(string: deepLink){
            print("inUserNotificationCenter")
            Task {
                await app?.handleDeeplink(from: url)
            }
        }
    }
}

 @main
struct KildeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var navigationRouter = KildeNavigationRouter()
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            KildeSplashScreenView()
                .environmentObject(navigationRouter)
                .environmentObject(authViewModel)
                .onAppear {
                    Log.shared.event(.appLaunch)
                    delegate.app = self
                    
                    if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasSetSources.key) {
                        UserDefaults.standard.set(["VG", "E24"], forKey: UserDefaultsKeys.selectedSources.key)
                    }
                }
                .onOpenURL { url in
                    Task {
                        await handleDeeplink(from: url)
                    }
                }
        }
    }
}


extension KildeApp {
    func handleDeeplink(from url: URL) async {
        let routeFinder = RouteFinder()
        if let route = await routeFinder.find(from: url, vm: ArticleListViewModel(articleService: ArticleServiceImpl())) {
            navigationRouter.push(to: route)
        }
    }
}
