import UIKit

public struct DefaultRouteProvider: RouteProvider {
    
    public func check(_ routeInfo: RouteInfo) -> Bool {
        true
    }
    
    public func transition(controller: UIViewController, transition: RouteTransition) -> Bool {
        fatalError("should be implemented")
    }
    
}
