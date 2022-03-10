import Foundation

public protocol RouteRemoteInfoProvider {
    var group: String { get set }
    var path: String { get set }
    var targetName: String { get set }
}

public protocol RouteRemoteProvider {
    var routes: [RouteRemoteInfoProvider] { get set }
    var actions: [RouteRemoteInfoProvider] { get set }
}
