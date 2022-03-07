import Foundation
import UIKit
import SafariServices

public protocol RouteProvider {
    
    /// check scheme with routeInfo, please add ["http", "https"] if you want pass web route
    /// - Returns: Bool
    func check(_ routeInfo: RouteInfo) -> Bool
    func transition(controller: UIViewController, transition: RouteTransition) -> Bool
    
    // optional
    func willStart(_ route: RouteTarget)
    func didEnd(_ route: RouteTarget, routeInfo: RouteInfo)
    func errorCatch(_ error: RouteError)
    
    func makeController(type: UIViewController.Type) -> UIViewController?
    
    func webController(_ routeInfo: RouteInfo) -> UIViewController?
    func isWebRoute(_ routeInfo: RouteInfo) -> Bool
}

extension RouteProvider {
    public func willStart(_ route: RouteTarget) { }
    public func didEnd(_ route: RouteTarget, routeInfo: RouteInfo) { }
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

// MARK: - DefaultRouteProvider
public struct DefaultRouteProvider: RouteProvider {
    public func check(_ routeInfo: RouteInfo) -> Bool {
        true
    }
    
    public func transition(controller: UIViewController, transition: RouteTransition) -> Bool {
        fatalError("should be implemented")
    }
}
