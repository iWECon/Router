import Foundation
import UIKit

/// Module route target
///
/// Contains two cases:
///
/// * execute something action with `RouteAction`
///
/// ```swift
/// case action(_ routeAction: RouteAction.Type, params: [String: Any]?)
/// ```
///
/// * execute something action without `RouteAction`
///
/// ```swift
/// case actionMapping(_ mapping: (_ params: [String: Any]?) throws -> Void, params: [String: Any]? = nil)
/// ```
///
/// * show a `UIViewController`
///
/// ```swift
/// case controller(_ controller: UIViewController, transition: RouteTransition = .push)
/// ```
///
/// * use other `ModuleRoute`
/// ```swift
/// case route(_ moduleRoute: ModuleRoute)
/// ```
///
public enum ModuleRouteTarget: CustomStringConvertible {
    
    /// execute something action with `RouteAction`
    case action(_ routeAction: RouteAction.Type, params: [String: Any]? = nil)
    
    /// execute something action without `RouteAction`
    case actionMapping(_ mapping: (_ params: [String: Any]) throws -> Void, params: [String: Any]? = nil)
    
    /// show a `UIViewController`
    case controller(_ controller: UIViewController, transition: RouteTransition = .push())
    
    /// a web
    case web(_ webURLString: String)
    
    /// use other `ModuleRoute`
    case route(_ moduleRoute: ModuleRoute)
    
    /// use remote route from server
    case remote(_ remoteRoute: String)
    
    public var description: String {
        switch self {
        case .action(let action, let params):
            return " ModuleRouteTarget { action: \(action), params: \(params?.description ?? "NONE") }"
            
        case .actionMapping(_, let params):
            return " ModuleRouteTarget { action: actionMapping, params: \(params?.description ?? "NONE") }"
            
        case .controller(let controller, let transition):
            return " ModuleRouteTarget { controller: \(String(describing: controller.self)) with transition: \(transition) }"
            
        case .web(let webURLString):
            return " ModuleRouteTarget { WebURLString: \(webURLString) }"
            
        case .route(let moduleRoute):
            return " ModuleRoute:\(moduleRoute.description)"
            
        case .remote(let remoteRoute):
            return " ModuleRouteTarget { remoteRoute: \(remoteRoute) }"
        }
    }
}
