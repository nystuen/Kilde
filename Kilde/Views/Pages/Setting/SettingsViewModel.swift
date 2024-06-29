import Foundation
import Combine
import SwiftUI
#if os(iOS)
import FirebaseAuth
#endif

class SettingsViewModel: ObservableObject {
    @Published var availableSources: [Source]?
    @Published var selectedSources: [Source] = []
    @Published var state: ResultState = .loading
    @Published var notificationToggle = false
    @Published var notificationsDisabledInSettingAlertEnabled = false
    private let sourceService = SourceService.shared
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        setupBindings()
        setupNotifications()
    }
    
    func onAppear() {
#if os(iOS)

        Task {
            await NotificationService.shared.requestAuthorization()
        }
        #endif
        loadSelectedSources()
    }


    private func setupNotifications() {
#if os(iOS)
        NotificationService.shared.$hasPermission
            .sink { notificationEnabledInSettings in
                let notificationsEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.notificationsEnabled.key)
                DispatchQueue.main.async {
                    self.notificationToggle = notificationsEnabled && notificationEnabledInSettings
                }
            }
            .store(in: &cancellables)
#endif
    }
    
    func loadSelectedSources() {
        selectedSources = sourceService.selectedSources
    }
    
    private func setupBindings() {
        sourceService.fetchSources()
            .sink { completion in
                switch completion {
                case .finished:
                    print("nice")
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            } receiveValue: { sources in
                self.availableSources = sources
                self.state = .success
            }
            .store(in: &cancellables)

        
        sourceService.$selectedSources
            .receive(on: DispatchQueue.main)
            .assign(to: \.selectedSources, on: self)
            .store(in: &cancellables)
    }
    
    func saveSelectedSources() {
        sourceService.selectedSources = selectedSources
        sourceService.saveSelectedSources()
    }
    
    func updateSource(source: Source, enabled: Bool) {
        sourceService.updateSource(source: source, enabled: enabled)
    }
#if os(iOS)

    func requestNotificationPermission(enabled: Bool) {
        guard enabled else {
            notificationToggle = false
            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.notificationsEnabled.key)
            return
        }
        
        if NotificationService.shared.hasPermission {
            notificationToggle = true
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.notificationsEnabled.key)
        } else {
            Task {
                await NotificationService.shared.requestAuthorization()
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let hasPermission = NotificationService.shared.hasPermission
                    notificationToggle = hasPermission
                    UserDefaults.standard.set(hasPermission, forKey: UserDefaultsKeys.notificationsEnabled.key)
                    notificationsDisabledInSettingAlertEnabled = !hasPermission
                }
            }
        }
    }
    

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    #endif
}
