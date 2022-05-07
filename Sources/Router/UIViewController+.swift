import UIKit

// Default implemention
extension UIViewController: _UIViewControllerRouteParamsMapping {
    open func routeParamsMappingWillStart() { }
    open func routeParamsMappingDidFinish() { }
    
    open func routeParamsMappingProcess(_ params: [String : Any]) {
        let mirror = Mirror(reflecting: self)
        for (key, value) in mirror.children {
            let peropertyAliasName = (value as? _RouteParams)?.aliasNames ?? []
            var aliasName: Set<String> = Set(peropertyAliasName)
            
            // set the property original name to aliasName
            if let labelName = key, !aliasName.contains(labelName) {
                let value = labelName.replacingOccurrences(of: "_", with: "")
                aliasName.insert(value)
            }
            
            guard let mapping: _RouteParamsMapping = value as? _RouteParamsMapping else {
                continue
            }
            
            // traverse aliasName and cast value to required type
            for name in aliasName {
                guard params.keys.contains(name),
                      let willSetValue = params[name]
                else {
                    continue
                }
                mapping.mapping(value: willSetValue)
            }
        }
    }
}
