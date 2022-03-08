import UIKit

struct _DefaultRouteProvider: RouteProvider {
    
    func check(_ routeInfo: RouteInfo) -> Bool {
        true
    }
    
    func transition(controller: UIViewController, transition: RouteTransition) -> Bool {
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
