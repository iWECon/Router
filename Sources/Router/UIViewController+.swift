import UIKit

// Default implemention
extension UIViewController: _UIViewControllerRouteParamsMapping {
    open func routeParamsMappingWillStart() { }
    open func routeParamsMappingDidFinish() { }
    
    open func routeParamsMappingProcess(_ params: [String : Any]) {
        let mirror = Mirror(reflecting: self)
        for (_, value) in mirror.children {
            guard let aliasName: [String] = (value as? _RouteParams)?.aliasNames,
                  let mapping: _RouteParamsMapping = value as? _RouteParamsMapping
            else {
                continue
            }
            
            for name in aliasName {
                guard params.keys.contains(name),
                      let willSetValue = params[name]
                else {
                    continue
                }
                
                guard !mapping.mapping(value: willSetValue) else {
                    continue
                }
                // built-in mapping
                builtInMapping(cast: value, value: willSetValue)
            }
        }
    }
}

extension UIViewController {
    
    // MARK: Built-in mapping
    private func builtInMapping(cast: Any, value: Any) {
        guard let value = value as? String else {
            return
        }
        let nsValue: NSString = value as NSString
        
        // MARK: String
        if let rp = cast as? RouteParams<String> {
            rp.value = value
        } else if let rp = cast as? RouteParams<String?> {
            rp.value = value
            
            // MARK: Int
        } else if let rp = cast as? RouteParams<Int> {
            rp.value = nsValue.integerValue
        } else if let rp = cast as? RouteParams<Int?> {
            rp.value = nsValue.integerValue
            
            // MARK: Int32
        } else if let rp = cast as? RouteParams<Int32> {
            rp.value = nsValue.intValue
        } else if let rp = cast as? RouteParams<Int32?> {
            rp.value = nsValue.intValue
            
            // MARK: Int64
        } else if let rp = cast as? RouteParams<Int64> {
            rp.value = Int64(nsValue.integerValue)
        } else if let rp = cast as? RouteParams<Int64?> {
            rp.value = Int64(nsValue.integerValue)
            
            // MARK: Float
        } else if let rp = cast as? RouteParams<Float> {
            rp.value = nsValue.floatValue
        } else if let rp = cast as? RouteParams<Float?> {
            rp.value = nsValue.floatValue
            
            // MARK: Double
        } else if let rp = cast as? RouteParams<Double> {
            rp.value = nsValue.doubleValue
        } else if let rp = cast as? RouteParams<Double?> {
            rp.value = nsValue.doubleValue
            
            // MARK: CGFloat
        } else if let rp = cast as? RouteParams<CGFloat> {
            rp.value = CGFloat(nsValue.floatValue)
        } else if let rp = cast as? RouteParams<CGFloat?> {
            rp.value = CGFloat(nsValue.floatValue)
            
            // MARK: Bool
        } else if let rp = cast as? RouteParams<Bool> {
            rp.value = nsValue.boolValue
        } else if let rp = cast as? RouteParams<Bool?> {
            rp.value = nsValue.boolValue
        }
    }
    
}
