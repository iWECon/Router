import UIKit

public struct DefaultRouteProvider: RouteProvider {
    
    public func check(_ routeInfo: RouteInfo) -> Bool {
        true
    }
    
    public func transition(controller: UIViewController, transition: RouteTransition) -> Bool {
        assert({ print("You should implement RouteProvider"); return true }())
        
        switch transition {
        case .push:
            // do push action
            return true
            
        case .presented:
            // do presented action
            return true
        }
    }
    
}
