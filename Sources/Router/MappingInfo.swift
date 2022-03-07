import UIKit

public struct MappingInfo {
    public let group: String
    public let maps: [RouteMap]
    public init(group: String, maps: [RouteMap]) {
        self.group = group
        self.maps = maps
    }
    
    /// Convert Mapping info to [String: MappingInfo>
    /// - Returns: (routes, actions)
    func convert() -> (
        routes: [String: MappingInfo.Route],
        actions: [String: MappingInfo.Action]
    ) {
        var _routes: [String: MappingInfo.Route] = [:]
        var _actions: [String: MappingInfo.Action] = [:]
        
        for map in maps {
            switch map {
            case let .route(path, target, remark):
                let _key: String
                if let index = path.firstIndex(of: "?") {
                    let endIndex = path.index(index, offsetBy: -1)
                    _key = group + path[...endIndex]
                } else {
                    _key = group + path
                }
                _routes[_key] = MappingInfo.Route(target: target, requiredInfo: Route.RequiredInfo(path), remark: remark)
                
            case let .action(path, target, remark):
                let _key = group + path
                _actions[_key] = MappingInfo.Action(target: target, remark: remark)
            }
        }
        
        return (_routes, _actions)
    }
}

// MARK: - Infos
extension MappingInfo {
    
    struct Route: CustomStringConvertible {
        
        struct RequiredInfo: CustomStringConvertible {
            var params: Set<String> = []
            
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
                        return
                    }
                    
                    let params = result.replacingOccurrences(of: "*", with: "").components(separatedBy: "/")
                    for param in params {
                        self.params.insert(param)
                    }
                }
            }
            
            var description: String {
                if params.isEmpty {
                    return "Requried: None"
                }
                return "Required: \(params.map({ "`\($0)`" }).joined(separator: " or ")) "
            }
        }
        
        var target: UIViewController.Type
        var requiredInfo: RequiredInfo
        var remark: String?
        
        var description: String {
            "Route { target: \(target), \(requiredInfo), remark: \(remark ?? "NONE") } "
        }
    }
    
    struct Action: CustomStringConvertible {
        var target: RouteAction.Type
        var remark: String?
        
        var description: String {
            "Action { target: \(target), remark: \(remark ?? "NONE") } "
        }
    }
}
