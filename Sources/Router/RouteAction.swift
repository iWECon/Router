import Foundation

public protocol RouteAction: RouteTarget {
    static func routeAction(_ routeInfo: RouteInfo?) -> Bool
}
