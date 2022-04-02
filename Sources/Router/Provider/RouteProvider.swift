import Foundation
import SafariServices

public protocol RouteProvider {
    
    /// If check routeInfo.scheme. Please add ["http", "https"] if you want pass web route.
    /// - Returns: return true to continue handle, return false to stop.
    func processible(_ routeInfo: RouteInfo) -> Bool
    
    /// Transition to controller with RouteTransition (push or presented).
    /// - Returns: return true if successed else return false.
    func transition(controller: UIViewController, transition: RouteTransition) -> Bool
    
    // optional
    /// Error catch when route handle happend error.
    func errorCatch(_ error: RouteError)
    
    /// Parse route with yourself.
    /// Convert other routes to compatible routes.
    ///
    /// - Parameter route: route
    /// - Returns: newRoute or nil (nil means no conversion required).
    func parseRoute(_ route: String) throws -> ParseInfo?
    
    func back(_ back: RouterBack, animated: Bool, defer: (() -> Void)?) -> Bool
    
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
}

extension RouteProvider {
    
    public func parseRoute(_ route: String) throws -> ParseInfo? {
        nil
    }
    
    public func makeController(type: UIViewController.Type) -> UIViewController? {
        type.init()
    }
    
    public func errorCatch(_ error: RouteError) {
        assert({ print(error.localizedDescription); return true }())
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
    
    public func back(_ back: RouterBack, animated: Bool, defer: (() -> Void)?) -> Bool {
        true
    }
    
}
