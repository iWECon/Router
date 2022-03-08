import UIKit

/// Mapping params to controller instance
@objc public protocol _UIViewControllerRouteMapping {
    /// Will start mapping
    @objc func routeWillStartMapping()
    
    /// Mapping, you can override in controller instance and call super.mapping(params:)
    @objc func routeMapping(params: [String: String])
    
    /// Did finish mapping
    @objc func routeDidFinishMapping()
}

// Default implemention
extension UIViewController: _UIViewControllerRouteMapping {
    public func routeWillStartMapping() { }
    public func routeDidFinishMapping() { }
    
    public func routeMapping(params: [String : String]) {
        let mirror = Mirror(reflecting: self)
        for (_, value) in mirror.children {
            guard let aliasName = (value as? _RouteParams)?.aliasNames,
                  let mapping = value as? _RouteParamsMapping
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
    
    // MARK: Built-in mapping
    private func builtInMapping(cast: Any, value: String) {
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
