import Foundation
import SafariServices

public protocol RouteProvider {
    
    /// If check routeInfo.scheme. Please add ["http", "https"] if you want pass web route.
    /// use `RouteError.processible(_ reason: String)` to quickly throw an error
    /// Throw an error to stop running
    func processible(_ routeInfo: RouteInfo) throws
    
    /// Transition to controller with RouteTransition (push or presented)
    /// Use `RouteError.transitionFailure(_ reason: String)` to quickly throw an error
    /// Throw an error to stop running
    func transition(controller: UIViewController, transition: RouteTransition) throws
    
    /// Error catch when route handle happend error.
    func errorCatch(_ error: RouteError)
    
    /// Parse route with yourself.
    /// Convert other routes to compatible routes.
    ///
    /// - Parameter route: route
    /// - Returns: newRoute or nil (nil means no conversion required).
    func parseRoute(_ route: String) throws -> ParseInfo?
    
    /// Make a UIViewController with UIViewController.Type.
    /// - Returns: return a valid controller, return nil if can't create controller with type.
    func makeController(type: UIViewController.Type) -> UIViewController?
    
    /// Make web controller with RouteInfo.
    /// If need set url, use routeInfo.originalRoute to set it.
    ///
    /// - Returns: return a valid web controller, return nil if can't create web controller with RouteInfo.
    func webController(_ routeInfo: RouteInfo) -> UIViewController?
    
    /// Check if the route is web route.
    /// - Returns: return true if the route prefix contains "http" or "https" else return false.
    func isWebScheme(_ routeInfo: RouteInfo) -> Bool
    
    /// Will start from current controller transition to another controller
    func transitionWillStart(controller: UIViewController, transition: RouteTransition) throws
    
    /// Transition from current controller to another controller did finish
    func transitionDidFinish(controller: UIViewController, transition: RouteTransition) throws
}

extension RouteProvider {
    public func processible(_ routeInfo: RouteInfo) throws { }
    public func parseRoute(_ route: String) throws -> ParseInfo? {
        nil
    }
    
    public func makeController(type: UIViewController.Type) -> UIViewController? {
        type.init()
    }
    
    public func errorCatch(_ error: RouteError) {
        logger.error(error.localizedDescription)
    }
    
    public func webController(_ routeInfo: RouteInfo) -> UIViewController? {
        guard let routeURL = URL(string: routeInfo.originalRoute) else {
            return nil
        }
        return SFSafariViewController(url: routeURL)
    }
    
    public func isWebScheme(_ routeInfo: RouteInfo) -> Bool {
        ["http", "https"].contains(routeInfo.scheme)
    }
    
    public func transitionWillStart(controller: UIViewController, transition: RouteTransition) throws { }
    public func transition(controller: UIViewController, transition: RouteTransition) throws { }
    public func transitionDidFinish(controller: UIViewController, transition: RouteTransition) throws { }
}
