import Foundation
import UIKit

public enum RouteTransition {
    case push(animated: Bool = true)
    case presented(animated: Bool = true, completion: (() -> Void)? = nil)
}

extension RouteTransition: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .push(let animated):
            return "RouteTransition { push, animated: \(animated) }"
        case .presented(let animated, let completion):
            return "RouteTransition { presented, animated: \(animated), completion: \(completion != nil ? "yes" : "no") }"
        }
    }
}

// MARK: Extensions
extension Router {
    
    internal static func transitionChain(controller: UIViewController, transition: RouteTransition) throws -> Bool {
        try self.provider.transitionWillStart(controller: controller, transition: transition)
        let value = self.provider.transition(controller: controller, transition: transition)
        try self.provider.transitionDidFinish(controller: controller, transition: transition)
        return value
    }
}
