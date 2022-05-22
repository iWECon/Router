import UIKit

/// Collect mappping info
///
/// use `Router.load(mapping: RouteMapping...) to load it`
public struct RouteMapping {
    
    public let group: String
    public let maps: [RouteMap]
    public init(group: String, maps: [RouteMap]) {
        self.group = group
        self.maps = maps
    }
    
    /// Convert Mapping info to [String: RouteMapping>
    /// - Returns: (routes, actions)
    func convert() -> (
        routes: [String: RouteMapping.Route],
        actions: [String: RouteMapping.Action],
        actionMappings: [String: RouteMapping.ActionMapping]
    ) {
        var _routes: [String: RouteMapping.Route] = [:]
        var _actions: [String: RouteMapping.Action] = [:]
        var _actionMappings: [String: RouteMapping.ActionMapping] = [:]
        
        for map in maps {
            switch map {
            case .route(let path, let target):
                let _key: String
                if let index = path.firstIndex(of: "?") {
                    let endIndex = path.index(index, offsetBy: -1)
                    _key = group + path[...endIndex]
                } else {
                    _key = group + path
                }
                _routes[_key.lowercased()] = RouteMapping.Route(target: target, requiredInfo: RequiredInfo(path))
                
            case .action(let path, let target):
                let _key: String
                if let index = path.firstIndex(of: "?") {
                    let endIndex = path.index(index, offsetBy: -1)
                    _key = group + path[...endIndex]
                } else {
                    _key = group + path
                }
                _actions[_key.lowercased()] = RouteMapping.Action(target: target, requiredInfo: RequiredInfo(path))
                
            case .actionMapping(let path, let action):
                let _key: String
                if let index = path.firstIndex(of: "?") {
                    let endIndex = path.index(index, offsetBy: -1)
                    _key = group + path[...endIndex]
                } else {
                    _key = group + path
                }
                _actionMappings[_key.lowercased()] = RouteMapping.ActionMapping(mapping: action, requiredInfo: RequiredInfo(path))
            }
        }
        
        return (_routes, _actions, _actionMappings)
    }
}

protocol RouteMappingParamsRequriedable {
    var requiredInfo: RouteMapping.RequiredInfo { get set }
}

extension RouteMapping {
    
    // MARK: Route
    struct Route: CustomStringConvertible, RouteMappingParamsRequriedable {
        let target: UIViewController.Type
        var requiredInfo: RequiredInfo
        
        var description: String {
            "Route { target: \(target), \(requiredInfo) } "
        }
    }
    
    // MARK: ActionMapping
    struct ActionMapping: CustomStringConvertible, RouteMappingParamsRequriedable {
        let mapping: RouteMap.ActionMapping
        var requiredInfo: RequiredInfo
        
        var description: String {
            "Route { actionMapping, \(requiredInfo) }"
        }
    }
    
    // MARK: Action
    struct Action: CustomStringConvertible, RouteMappingParamsRequriedable {
        let target: RouteAction.Type
        var requiredInfo: RequiredInfo
        
        var description: String {
            "Action { target: \(target), \(requiredInfo) } "
        }
    }
    
    // MARK: RequiredInfo
    struct RequiredInfo: CustomStringConvertible {
        var params: [Set<String>] = []
        
        init(_ path: String) {
            guard let query = path.components(separatedBy: "?").last,
                  !query.isEmpty
            else {
                return
            }
            
            for item in query.components(separatedBy: "&") {
                let item = item.replacingOccurrences(of: " ", with: "")
                let start = item.index(item.startIndex, offsetBy: 1)
                let end = item.index(item.endIndex, offsetBy: -2)
                
                let result = item[start...end]
                guard result.hasPrefix("*") else {
                    continue
                }
                
                let params = result.replacingOccurrences(of: "*", with: "").components(separatedBy: "/")
                self.params.append(Set<String>(params))
            }
        }
        
        func diffable(from keyNames: [String]) -> String {
            var noContains: [[String]] = []
            
            for param in params {
                if param.filter({ keyNames.contains($0) }).isEmpty {
                    noContains.append(Array(param))
                }
            }
            return noContains.map({ $0.map({ "`\($0)`" }).joined(separator: " or ") }).joined(separator: " and ")
        }
        
        var description: String {
            if params.isEmpty {
                return "Requried: None"
            }
            return "Required: \(params.compactMap({ $0.map({ "`\($0)`" }).joined(separator: " or ") }).joined(separator: " and\n")) "
        }
    }
    
}
