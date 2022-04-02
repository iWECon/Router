import Foundation

/// Mapping params to controller instance
@objc public protocol _UIViewControllerRouteParamsMapping {
    /// Will start mapping
    @objc func routeParamsMappingWillStart()
    
    /// Mapping, you can override in controller instance and call super.mapping(params:)
    /// 默认的解析只能处理基本类型的数据，详情可见：UIViewController+.swift
    /// 在定义 @RouteParams 时，可对参数进行自定义解析，详情可见：RouteParams.swift
    @objc func routeParamsMappingProcess(_ params: [String: Any])
    
    /// Did finish mapping
    @objc func routeParamsMappingDidFinish()
}
