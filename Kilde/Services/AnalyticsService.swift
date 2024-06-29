import FirebaseAnalytics

class Log {
    static let shared = Log()
    
    private init() {}
    
    func event(_ event: LogEvent) {
        var parameters: [String: Any] = [:]
        
        switch event {
        case .appLaunch:
            break
        case .articleTapped(let article):
            parameters = [event.eventName: article.headline]
        case .darkModeEnabled(let enabled):
            parameters = [event.eventName: enabled.description]
        case .sourcesUpdated(let sourceIds):
            parameters = Dictionary(uniqueKeysWithValues: sourceIds.map { ($0, true) })
        }
        
        print("LOG | Event: \(event.eventName) | Params: \(parameters)")
        Analytics.logEvent(event.eventName, parameters: parameters)
    }
}

enum LogEvent {
    case appLaunch, articleTapped(Article), darkModeEnabled(Bool), sourcesUpdated([String])
    
    var eventName: String {
        switch self {
        case .appLaunch: return "appLauch"
        case .articleTapped: return "articleTapped"
        case .darkModeEnabled: return "darkModeEnabled"
        case .sourcesUpdated: return "sourcesUpdated"
        }
    }
}
