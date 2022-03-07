import Foundation

public struct RouteInfo: CustomStringConvertible {
    
    public var scheme: String
    public var group: String
    public var path: String
    public var params: [String: String]
    public var transition: RouteTransition
    public var originalRoute: String
    
    public init(scheme: String, group: String, path: String, params: [String : String], transition: RouteTransition, originalRoute: String) {
        self.scheme = scheme
        self.group = group
        self.path = path
        self.params = params
        self.transition = transition
        self.originalRoute = originalRoute
    }
    
    var routeKey: String {
        group + path
    }
    
    public var description: String {
        "Route { \(originalRoute) }"
    }
}
