import UIKit

public enum RouteMap {
    case route(_ path: String, target: UIViewController.Type, remark: String? = nil)
    case action(_ path: String, target: RouteAction.Type, remark: String? = nil)
}
