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
        actions: [String: RouteMapping.Action]
    ) {
        var _routes: [String: RouteMapping.Route] = [:]
        var _actions: [String: RouteMapping.Action] = [:]
        
        for map in maps {
            switch map {
            case let .route(path, target):
                let _key: String
                if let index = path.firstIndex(of: "?") {
                    let endIndex = path.index(index, offsetBy: -1)
                    _key = group + path[...endIndex]
                } else {
                    _key = group + path
                }
                _routes[_key] = RouteMapping.Route(target: target, requiredInfo: Route.RequiredInfo(path))
                
            case let .action(path, target):
                let _key = group + path
                _actions[_key] = RouteMapping.Action(target: target)
            }
        }
        
        return (_routes, _actions)
    }
}

// MARK: - Infos
extension RouteMapping {
    
    struct Route: CustomStringConvertible {
        
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
        
        var target: UIViewController.Type
        var requiredInfo: RequiredInfo
        
        var description: String {
            "Route { target: \(target), \(requiredInfo) } "
        }
    }
    
    struct Action: CustomStringConvertible {
        var target: RouteAction.Type
        
        var description: String {
            "Action { target: \(target) } "
        }
    }
}
