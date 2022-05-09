//
//  Created by i on 2022/5/7.
//

import UIKit

// MARK: Extensions
extension Router {
    
    internal static func transitionChain(controller: UIViewController, transition: RouteTransition) throws {
        try self.provider.transitionWillStart(controller: controller, transition: transition)
        try self.provider.transition(controller: controller, transition: transition)
        try self.provider.transitionDidFinish(controller: controller, transition: transition)
    }
}

// MARK: Error forward
extension Router {
    
    internal static func errorForward(_ error: Error) {
        if let routeError = error as? RouteError {
            self.provider.errorCatch(routeError)
        } else {
            self.provider.errorCatch(.error(error))
        }
    }
}
