import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var selectedWebsites: Set<NewsWebsite> = []
    private let selectedWebsiteService = SelectedWebsiteService.shared
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        setupBindings()
    }
    
    func loadSelectedWebsites() {
        selectedWebsites = selectedWebsiteService.selectedWebsites
    }
    
    private func setupBindings() {
        selectedWebsiteService.$selectedWebsites
            .receive(on: DispatchQueue.main)
            .assign(to: \.selectedWebsites, on: self)
            .store(in: &cancellables)
    }
    
    func saveSelectedWebsites() {
        selectedWebsiteService.selectedWebsites = selectedWebsites
        selectedWebsiteService.saveSelectedWebsites()
    }
    
    func updateWebsite(website: NewsWebsite, enabled: Bool) {
        selectedWebsiteService.updateWebsite(website: website, enabled: enabled)
    }
}
