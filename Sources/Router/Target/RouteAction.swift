import Foundation

/// RouteAction, executable action without UIViewController
///
/// Do something without UIViewController
/// * Send messages
/// * Update static resources (image, theme or other something)
///
/// Define in MappingInfo
/// Example:
/// ```swift
/// struct BaseActions: RouteAction {
///     static func routeAction(_ routeInfo: RouteInfo?) -> Bool {
///         guard let routeInfo = routeInfo else {
///             return true
///         }
///         // do something
///     }
/// }
///
/// let actionsMapping = MappingInfo(group: "base", maps: [
///     // BaseActions should inherits the protocol `RouteAction`
///     .action("/updateResources", target: BaseActions.self, remark: "update resources")
/// ])
/// ```
public protocol RouteAction: RouteTarget {
    static func routeAction(_ params: [String: Any]) -> Bool
}
