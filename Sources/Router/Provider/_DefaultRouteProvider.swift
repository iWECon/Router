import UIKit

struct _DefaultRouteProvider: RouteProvider {
    
    func processible(_ routeInfo: RouteInfo) throws { }
    
    func transition(controller: UIViewController, transition: RouteTransition) throws {
        logger.warning("⚠️ You should implement RouteProvider")

        switch transition {
        case .push:
            // do push action
            break

        case .presented:
            // do presented action
            break
        }
    }
    
}
