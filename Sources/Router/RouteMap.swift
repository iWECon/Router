import UIKit

/// Priority: `.actionMapping` > `.action` > `.route`
public enum RouteMap {
    
    /// show a `UIViewController`
    case route(_ path: String, target: UIViewController.Type)
    
    /// perform actions
    case action(_ path: String, target: RouteAction.Type)
    
    public typealias ActionMapping = (_ params: [String: Any]) throws -> Void
    /// perform actions without creating a new `RouteAction`
    case actionMapping(_ path: String, action: RouteMap.ActionMapping)
    
}
