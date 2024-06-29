import Foundation
import SwiftUI

final class KildeNavigationRouter: ObservableObject {
    @Published var newsRouter = NavigationRouter()
    @Published var settingsRouter = NavigationRouter()
    
    func push(to screen: Route) {
        switch screen {
        case .article(_, _):
            newsRouter.push(to: screen)
        case .webView(_, _, _):
            newsRouter.push(to: screen)
        case .sourcesView, .adminView, .feedback:
            settingsRouter.push(to: screen)
        }
    }
    
    func replace(with screen: Route) {
        switch screen {
        case .article(_, _):
            newsRouter.replace(with: screen)
        case .webView(_, _, _):
            newsRouter.replace(with: screen)
        case .sourcesView, .adminView, .feedback:
            settingsRouter.replace(with: screen)
        }
        
    }
}

final class NavigationRouter: ObservableObject {
    @Published var routes = [Route]()
    @Published var selectedItemId: String?
    
    func push(to screen: Route) {
        guard !routes.contains(screen) else {
            return
        }
        withAnimation {
            routes.append(screen)
        }
    }
    
    func goBack() {
        _ = routes.popLast()
    }
    
    func reset() {
        routes = []
    }
    
    func replace(stack: [Route]) {
        routes = stack
    }
    
    func replace(with screen: Route) {
        _ = routes.popLast()
        push(to: screen)
    }
}
