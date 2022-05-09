import Foundation
import UIKit

/// Module route target
///
/// Contains two cases:
///
/// * execute something without UIViewController
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
    
    /// execute something without UIViewController
    case action(_ routeAction: RouteAction.Type, params: [String: Any]? = nil)
    
    /// show a UIViewController
    case controller(_ controller: UIViewController, transition: RouteTransition = .push())
    
    public var description: String {
        switch self {
        case .action(let action, let params):
            return " ModuleRouteTarget { action: \(action), params: \(params?.description ?? "NONE") }"
            
        case .controller(let controller, let transition):
            return " ModuleRouteTarget { controller: \(String(describing: controller.self)) with transition: \(transition) }"
        }
    }
}

// MARK: RouteModuleError
public enum ModuleRouteError: Swift.Error, LocalizedError {
    case unprocessed(reason: String)
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
///
///     func processible() -> Bool {
///         switch self {
///         case .info(let userId):
///             return !userId.isEmpty
///         }
///     }
/// ```
public protocol ModuleRoute: RouteTarget, CustomStringConvertible {
    
    /// Target of route
    var target: ModuleRouteTarget { get }
    
    /// Return false or throw error to stop doing action (show controller or execution some action)
    /// use `ModuleRouteError.unprocessed(reason: String)` to quickly throw an error
    func processible() throws
}

extension ModuleRoute {
    public var description: String {
        target.description
    }
    
    public func processible() throws { }
}

// MARK: - Handle
public extension Router {
    
    @discardableResult static func navigate(to destination: ModuleRoute) -> Bool {
        do {
            switch destination.target {
            case .controller(let controller, let transition):
                try destination.processible()
                try self.transitionChain(controller: controller, transition: transition)
                return true
                
            case .action(let action, let params):
                try destination.processible()
                try action.routeAction(params ?? [:])
                return true
            }
        } catch {
            self.errorForward(error)
            return false
        }
    }
    
}
