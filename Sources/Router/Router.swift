import UIKit

public struct Router {
    private init() { }
    
    public static var provider: RouteProvider = DefaultRouteProvider()
}

public extension Router {
    private static var routes: RouteMapping<MappingInfo.Route> = .init()
    private static var actions: RouteMapping<MappingInfo.Action> = .init()
    
    static func load(mappingInfo: MappingInfo...) {
        for (_routes, _actions) in mappingInfo.map({ $0.convert() }) {
            self.routes.merge(values: _routes)
            self.actions.merge(values: _actions)
        }
    }
    
    /// Load route mapping from json
    /// - Parameter mapping: route mapping json
    static func load(mapping: [[String: Any]]) {

//        var _actions: [String: RouteInfo.Action] = [:]
//        var _routes: [String: RouteInfo.Route] = [:]
//        var _rewrites: [String: RouteInfo.Rewrite] = [:]
//
//        for mapp in mapping {
//            guard let type = mapp["type"] as? String, !type.isEmpty else {
//                continue
//            }
//
//            guard let map = mapp["info"] as? [String: Any],
//                  let mapPath = map["path"] as? String, !mapPath.isEmpty,
//                  let mapTarget = map["target"] as? String, !mapTarget.isEmpty,
//                  let mapRemark = map["remark"] as? String, !mapRemark.isEmpty
//            else {
//                continue
//            }
//
//            guard let targetClazz = NSClassFromString(mapTarget) else {
//                continue
//            }
//
//            let mapParams = map["params"] as? String
//
//            var versionRange: ClosedRange<Int>?
//            if let versionRangeInfo = map["versionRange"] as? String, versionRangeInfo.contains("...") {
//                let _info = versionRangeInfo.components(separatedBy: "...")
//                if let lowerBoundsInfo = _info.first, let upperBoundsInfo = _info.last,
//                   let lowerBounds = Int(lowerBoundsInfo), let upperBounds = Int(upperBoundsInfo) {
//                    versionRange = lowerBounds ... upperBounds
//                }
//            }
//
//            guard let filter = RouterManager.shared.provider.remoteRouteFilter?(type, mapPath, mapTarget, mapParams, mapRemark, versionRange),
//                  !filter
//            else {
//                continue
//            }
//
//            switch type {
//            case "action":
//                if let ra = targetClazz as? RouteAction.Type {
//                    let action = RouteInfo.Action(target: ra, remark: mapRemark)
//                    _actions[mapPath] = action
//                }
//            case "route":
//                if let rt = targetClazz as? UIViewController.Type {
//                    let route = RouteInfo.Route(target: rt, remark: mapRemark)
//                    _routes[mapPath] = route
//                }
//            case "rewrite":
//                guard let rw = targetClazz as? RouteTarget.Type else {
//                    continue
//                }
//                if let rcch = rw as? RouteCustomControllerHandler.Type {
//                    let rewrite = RouteInfo.Rewrite(target: rcch, remark: mapRemark)
//                    _rewrites[mapPath] = rewrite
//                    continue
//                }
//                if let ra = rw as? RouteAction.Type {
//                    let ra = RouteInfo.Rewrite(target: ra, remark: mapRemark)
//                    _rewrites[mapPath] = ra
//                    continue
//                }
//                if let c = rw as? UIViewController.Type {
//                    let c = RouteInfo.Rewrite(target: c, remark: mapRemark)
//                    _rewrites[mapPath] = c
//                    continue
//                }
//            default:
//                continue
//            }
//        }
//
//        self.actions.merge(values: _actions)
//        self.routes.merge(values: _routes)
//        self.rewrites.merge(values: _rewrites)
    }
    
}

// MARK: - Handle
public extension Router {
    
    @discardableResult static func handle(route: String, transition: RouteTransition = .push) -> Bool {
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
            return action.target.routeAction(routeInfo)
        }
        // route
        if let route = self.routes[routeInfo.routeKey],
           let controller = self.provider.makeController(type: route.target)
        {
            let diffable = route.requiredInfo.diffable(from: routeInfo.params.keys.map({ $0 }))
            if !diffable.isEmpty {
                throw RouteError.missingParams(diffable + ",\n" + routeInfo.description + ", \n" + route.requiredInfo.description)
            }
            
            controller.willStartMapping()
            controller.mapping(params: routeInfo.params)
            controller.didFinishMapping()
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
