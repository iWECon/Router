import Foundation

/// Mapping params to controller instance
@objc public protocol _UIViewControllerRouteParamsMapping {
    /// Will start mapping
    @objc func routeParamsMappingWillStart()
    
    /// Mapping, you can override in controller instance and call super.mapping(params:)
    @objc func routeParamsMappingProcess(_ params: [String: String])
    
    /// Did finish mapping
    @objc func routeParamsMappingDidFinish()
}
