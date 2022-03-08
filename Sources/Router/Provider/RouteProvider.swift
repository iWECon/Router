import Foundation
import SafariServices

public protocol RouteProvider {
    
    /// Check routeInfo.scheme. Please add ["http", "https"] if you want pass web route.
    /// - Returns: Bool
    func check(_ routeInfo: RouteInfo) -> Bool
    
    /// Transition to controller with RouteTransition (push or presented).
    /// - Returns: return true if successed else return false.
    func transition(controller: UIViewController, transition: RouteTransition) -> Bool
    
    // optional
    /// Error catch when route handle happend error.
    func errorCatch(_ error: RouteError)
    
    /// Make a UIViewController with UIViewController.Type.
    /// - Returns: return a valid controller, return nil if can't create controller with type.
    func makeController(type: UIViewController.Type) -> UIViewController?
    
    /// Make web controller with RouteInfo.
    /// - Returns: return a valid web controller, return nil if can't create web controller with RouteInfo.
    func webController(_ routeInfo: RouteInfo) -> UIViewController?
    
    /// Check if the route is web route.
    /// - Returns: return true if the route prefix contains "http" or "https" else return false.
    func isWebRoute(_ routeInfo: RouteInfo) -> Bool
}

extension RouteProvider {
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
    
    public func isWebRoute(_ routeInfo: RouteInfo) -> Bool {
        ["http", "https"].contains(routeInfo.scheme)
    }
    
}
