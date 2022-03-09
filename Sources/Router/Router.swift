import UIKit

public struct Router {
    private init() { }
    
    public static var provider: RouteProvider = _DefaultRouteProvider()
}

// MARK: - load mapping
public extension Router {
    /// Cached all routes.
    private static var routes: RouteCollect<MappingInfo.Route> = RouteCollect()
    
    /// Cached all actions.
    private static var actions: RouteCollect<MappingInfo.Action> = RouteCollect()
    
    /// Load mapping info
    /// - Parameter mappingInfo: MappingInfo...
    static func load(mappingInfo: MappingInfo...) {
        for (_routes, _actions) in mappingInfo.map({ $0.convert() }) {
            self.routes.merge(values: _routes)
            self.actions.merge(values: _actions)
        }
    }
    
    /// Load route mapping
    /// - Parameter routeRemote: RouteRemote use Codable initlized.
    static func load(routeRemote: RouteRemote) {
        var _routes: [String: MappingInfo.Route] = [:]
        var _actions: [String: MappingInfo.Action] = [:]
        
        for route in routeRemote.routes {
            guard let clazzName = NSClassFromString(route.targetName),
                  let vcTarget = clazzName as? UIViewController.Type
            else {
                continue
            }
            let key = route.group + route.path
            _routes[key] = MappingInfo.Route(target: vcTarget, requiredInfo: MappingInfo.Route.RequiredInfo(route.path))
        }
        
        for action in routeRemote.actions {
            guard let clazzName = NSClassFromString(action.targetName),
                  let actionTarget = clazzName as? RouteAction.Type
            else {
                continue
            }
            
            let key = action.group + action.path
            _actions[key] = MappingInfo.Action(target: actionTarget)
        }
        
        self.routes.merge(values: _routes)
        self.actions.merge(values: _actions)
    }
    
}

// MARK: - Handle
public extension Router {
    
    @discardableResult static func handle(route: String, transition: RouteTransition = .push()) -> Bool {
        do {
            return try handleRouteString(route, transition: transition)
        } catch {
            guard let routeError = error as? RouteError else {
                return false
            }
            self.provider.errorCatch(routeError)
        }
        return false
    }
    
    private static func handleRouteString(_ route: String, transition: RouteTransition) throws -> Bool {
        guard !route.isEmpty else {
            throw RouteError.empty
        }
        
        let routeInfo = try parseRoute(route, transition: transition)
        guard self.provider.check(routeInfo) else {
            throw RouteError.providerCancel("`check` return false")
        }
        
        // MARK: Web handle
        if self.provider.isWebRoute(routeInfo),
           let webController = self.provider.webController(routeInfo)
        {
            return self.provider.transition(controller: webController, transition: routeInfo.transition)
        }
        
        // MARK: Module handle
        // action
        if let action = self.actions[routeInfo.routeKey] {
            return action.target.routeAction(routeInfo.params)
        }
        // route
        if let route = self.routes[routeInfo.routeKey],
           let controller = self.provider.makeController(type: route.target)
        {
            let diffable = route.requiredInfo.diffable(from: routeInfo.params.keys.map({ $0 }))
            if !diffable.isEmpty {
                throw RouteError.missingParams(diffable + ",\n" + routeInfo.description + ", \n" + route.requiredInfo.description)
            }
            
            controller.routeParamsMappingWillStart()
            controller.routeParamsMappingProcess(routeInfo.params)
            controller.routeParamsMappingDidFinish()
            
            return self.provider.transition(controller: controller, transition: routeInfo.transition)
        }
        return false
    }
    
    // MARK: Parse route
    /// Check scheme, host and path
    /// - Parameter route: route
    private static func parseRoute(_ route: String, transition: RouteTransition) throws -> RouteInfo {
        guard let routeComponents: URLComponents = URLComponents(string: route) else {
            throw RouteError.invalid(route: route)
        }
        
        guard let scheme = routeComponents.scheme, !scheme.isEmpty else {
            throw RouteError.parseFailure("not found scheme from: \(route)")
        }
        
        guard let host = routeComponents.host, !host.isEmpty else {
            throw RouteError.parseFailure("not found host from: \(route)")
        }
        
        guard !routeComponents.path.isEmpty else {
            throw RouteError.parseFailure("not found path from: \(route)")
        }
        
        let queries = routeComponents.queryItems?.filter({ $0.value != nil })
            .map({ [$0.name: $0.value!] }) ?? []
        
        var queriesMerged = queries.first ?? [:]
        queries.forEach { value in
            queriesMerged.merge(value, uniquingKeysWith: { $1 })
        }
        
        let routeInfo = RouteInfo(
            scheme: scheme,
            group: host,
            path: routeComponents.path,
            params: queriesMerged,
            transition: transition,
            originalRoute: route
        )
        return routeInfo
    }
}
