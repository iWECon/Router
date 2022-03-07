import Foundation
import UIKit

/// Module route target
///
/// Contains two cases:
///
/// * executable something without UIViewController
///
/// ```swift
/// case action(_ routeAction: RouteAction.Type, params: [String: Any]?)
/// ```
///
/// * show a UIViewController
///
/// ```swift
/// case controller(_ controller: UIViewController, transition: RouteTransition = .push)
/// ```
///
public enum ModuleRouteTarget: CustomStringConvertible {
    
    /// executable something without UIViewController
    case action(_ routeAction: RouteAction.Type, params: [String: Any]?)
    
    /// show a UIViewController
    case controller(_ controller: UIViewController, transition: RouteTransition = .push)
    
    public var description: String {
        switch self {
        case .action(let action, let params):
            return " ModuleRouteTarget { action: \(action), params: \(params?.description ?? "NONE") }"
        case .controller(let controller, let transition):
            return " ModuleRouteTarget { controller: \(String(describing: controller.self)) with transition: \(transition) }"
        }
    }
}

// MARK: ModuleRoute

/// ModuleRoute
///
/// Use inside the project, differentiate according to the module
///
/// Example:
///
/// ```swift
/// enum UserRoute: ModuleRoute {
///     case info(userId: String)
///
///     var target: ModuleRouteTarget {
///         switch self {
///         case .info(let userId):
///             return .controller(UserController(userId: userId), transition: .presented)
///         }
///     }
/// }
/// ```
public protocol ModuleRoute: RouteTarget, CustomStringConvertible {
    
    /// Target of route
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
            
        case .action(let action, let params):
            return action.routeAction(params ?? [:])
        }
    }
    
}
