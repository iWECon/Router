import Foundation

public enum RouteTransition {
    case push(animated: Bool = true)
    case presented(animated: Bool = true, completion: (() -> Void)? = nil)
}
