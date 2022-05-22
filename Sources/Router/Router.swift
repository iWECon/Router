import UIKit

public struct Router {
    private init() { }
    
    public static var provider: RouteProvider = _DefaultRouteProvider()
}

// MARK: - load mapping
public extension Router {
    
    /// Cached all routes.
    private static var routes: RouteCollect<RouteMapping.Route> = RouteCollect()
    
    /// Cached all actions.
    private static var actions: RouteCollect<RouteMapping.Action> = RouteCollect()
    
    /// Cached all action mappings.
    private static var actionMappings: RouteCollect<RouteMapping.ActionMapping> = RouteCollect()
    
    static var description: String {
        var tmp: String = ""
        if !routes.isEmpty {
            tmp += "\(routes)\n"
        }
        if !actions.isEmpty {
            tmp += "\(actions)\n"
        }
        if !actionMappings.isEmpty {
            tmp += "\(actionMappings)"
        }
        return tmp
    }
    
    /// Load mapping info.
    /// - Parameter mapping: RouteMapping...
    static func load(mapping: RouteMapping...) {
        for (_routes, _actions, _actionMappings) in mapping.map({ $0.convert() }) {
            self.routes.merge(values: _routes)
            self.actions.merge(values: _actions)
            self.actionMappings.merge(values: _actionMappings)
        }
    }
    
    /// Load route mapping.
    /// `actionMapping` is not supported.
    ///
    /// - Parameter routeRemote: RouteRemote use Codable initlized.
    static func load(remote: RouteRemoteProvider) {
        var _routes: [String: RouteMapping.Route] = [:]
        var _actions: [String: RouteMapping.Action] = [:]
        
        for route in remote.routes {
            guard let clazzName = NSClassFromString(route.targetName),
                  let vcTarget = clazzName as? UIViewController.Type
            else {
                continue
            }
            let key = route.group + route.path
            _routes[key] = RouteMapping.Route(target: vcTarget, requiredInfo: RouteMapping.RequiredInfo(route.path))
        }
        
        for action in remote.actions {
            guard let clazzName = NSClassFromString(action.targetName),
                  let actionTarget = clazzName as? RouteAction.Type
            else {
                continue
            }
            
            let key = action.group + action.path
            _actions[key] = RouteMapping.Action(target: actionTarget, requiredInfo: RouteMapping.RequiredInfo(action.path))
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
            self.errorForward(error)
            return false
        }
    }
    
}

private extension Router {
    
    static func handleRouteString(_ route: String, transition: RouteTransition) throws -> Bool {
        guard !route.isEmpty else {
            throw RouteError.empty
        }
        
        let newRoute = try self.provider.parseRoute(route)?._route ?? route
        let routeInfo = try self.parseRoute(newRoute, transition: transition)
        try self.provider.processible(routeInfo)
        
        // MARK: Web handle
        if self.provider.isWebScheme(routeInfo),
           let webController = self.provider.webController(routeInfo)
        {
            try self.transitionChain(controller: webController, transition: transition)
            return true
        }
        
        // MARK: Module handle
        // actionMapping
        if let actionMapping = self.actionMappings[routeInfo.routeKey] {
            try actionMapping.mapping(routeInfo.params)
            return true
        }
        // action
        if let action = self.actions[routeInfo.routeKey] {
            try action.target.routeAction(routeInfo.params)
            return true
        }
        // route
        if let route = self.routes[routeInfo.routeKey],
           let controller = self.provider.makeController(type: route.target)
        {
            let diffable = route.requiredInfo.diffable(from: routeInfo.params.keys.map({ $0 }))
            if !diffable.isEmpty {
                throw RouteError.missingParams(diffable + ",\n   " + routeInfo.description + ", \n   " + route.requiredInfo.description)
            }
            
            controller.routeParamsMappingWillStart()
            controller.routeParamsMappingProcess(routeInfo.params)
            controller.routeParamsMappingDidFinish()
            
            try self.transitionChain(controller: controller, transition: transition)
            return true
        }
        
        throw RouteError.notFound(newRoute)
    }
    
    // MARK: Parse route
    /// Check scheme, host and path
    /// - Parameter route: route
    static func parseRoute(_ route: String, transition: RouteTransition) throws -> RouteInfo {
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
        
        let queries = (routeComponents.queryItems ?? [])
            .compactMap { queryItem -> (String, String)? in
                guard let value = queryItem.value,
                      !value.isEmpty,
                      let removingPercentValue = value.removingPercentEncoding,
                      !removingPercentValue.isEmpty
                else {
                    return nil
                }
                return (queryItem.name, removingPercentValue)
            }
        
        var params = Dictionary(uniqueKeysWithValues: queries)
        params.merge([
            "__group": host,
            "__path": routeComponents.path
        ], uniquingKeysWith: { $1 })
        
        let routeInfo = RouteInfo(
            scheme: scheme,
            group: host,
            path: routeComponents.path,
            params: params,
            transition: transition,
            originalRoute: route
        )
        return routeInfo
    }
}
