import UIKit

public enum RouteMap {
    /// show a UIViewController
    case route(_ path: String, target: UIViewController.Type)
    
    /// execute an action without UIViewController
    case action(_ path: String, target: RouteAction.Type)
}
