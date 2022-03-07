import Foundation
import UIKit

public enum ModuleRouteTarget: CustomStringConvertible {
    case action(_ routeAction: RouteAction.Type)
    case controller(_ controller: UIViewController, transition: RouteTransition = .push)
    
    public var description: String {
        switch self {
        case .action(let action):
            return " ModuleRouteTarget { action: \(action) }"
        case .controller(let controller, let transition):
            return " ModuleRouteTarget { controller: \(String(describing: controller.self)) with transition: \(transition) }"
        }
    }
}

// MARK: ModuleRoute

public protocol ModuleRoute: RouteTarget, CustomStringConvertible {
    var target: ModuleRouteTarget { get }
}
extension ModuleRoute {
    public var description: String {
        target.description
    }
}

// MARK: - Handle
public extension Router {
    
    @discardableResult static func handle(moduleRoute: ModuleRoute) -> Bool {
        self.provider.willStart(moduleRoute)
        
        switch moduleRoute.target {
        case .controller(let controller, let transition):
            return self.provider.transition(controller: controller, transition: transition)
            
        case .action(let action):
            return action.routeAction(nil)
        }
    }
    
}
