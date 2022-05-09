import Foundation

/// RouteAction, executable action without UIViewController
///
/// Do something without UIViewController
/// * Send messages
/// * Update static resources (image, theme or other something)
///
/// Define in RouteMapping
/// Example:
/// ```swift
/// struct BaseActions: RouteAction {
///     static func routeAction(_ params: [String: Any]) throws {
///         guard let action = params["action"] else {
///             throw RouteActionError.failure("invalid params")
///         }
///         // do something
///     }
/// }
///
/// let actionsMapping = RouteMapping(group: "base", maps: [
///     // BaseActions should inherits the protocol `RouteAction`
///     .action("/updateResources", target: BaseActions.self, remark: "update resources")
/// ])
/// ```
public protocol RouteAction: RouteTarget {
    
    /// use `RouteActionError` to quickly throw an error
    static func routeAction(_ params: [String: Any]) throws
}

public enum RouteActionError: Swift.Error, LocalizedError {
    case failure(_ reason: String)
    
    public var errorDescription: String? {
        switch self {
        case .failure(let reason):
            return "[RouteActionError] \(reason)"
        }
    }
}
