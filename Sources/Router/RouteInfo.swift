import Foundation

public struct RouteInfo: CustomStringConvertible {
    
    public let scheme: String
    public let group: String
    public let path: String
    public let params: [String: String]
    public let transition: RouteTransition
    public let originalRoute: String
    
    public init(scheme: String, group: String, path: String, params: [String : String], transition: RouteTransition, originalRoute: String) {
        self.scheme = scheme
        self.group = group
        self.path = path
        self.params = params
        self.transition = transition
        self.originalRoute = originalRoute
    }
    
    var routeKey: String {
        (group + path).lowercased()
    }
    
    public var description: String {
        "RouteInfo { \(scheme)://\(group)\(path), params: \(params) }"
    }
}
