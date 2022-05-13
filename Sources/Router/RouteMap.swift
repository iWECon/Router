import UIKit

public enum RouteMap {
    /// show a `UIViewController`
    case route(_ path: String, target: UIViewController.Type)
    
    /// execute an action with `RouteAction`
    case action(_ path: String, target: RouteAction.Type)
}
