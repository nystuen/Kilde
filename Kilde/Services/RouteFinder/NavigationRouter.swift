import Foundation
import SwiftUI

final class KildeNavigationRoutefr: ObservedObject {
    Published var newsR
}

final class KildeNavigationRouter: ObservableObject {
    
    @Published var routes = [Route]()
    @Published var selectedItemId: String?
        
    func push(to screen: Route) {
        guard !routes.contains(screen) else {
            return
        }
        routes.append(screen)
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
}
