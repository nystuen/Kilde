import Foundation

enum UserDefaultsKeys: String, CaseIterable {
    case hasSeenOnboarding, articleDisplayMode, listDisplayMode, notificationsEnabled, hasSetSources, selectedSources, seenArticles
    
    var key: String {
        return self.rawValue
    }
}
