//
//  Created by iww on 2022/5/13.
//

import Foundation
import UIKit

// MARK: ModuleRoute

/// ModuleRoute
///
/// Use inside the project, differentiate according to the module
///
/// Example:
///
/// ```swift
/// enum UserRoute: ModuleRoute {
///     case info(userId: String)
///
///     var target: ModuleRouteTarget {
///         switch self {
///         case .info(let userId):
///             return .controller(UserController(userId: userId), transition: .presented)
///         }
///     }
///
///     func processible() -> Bool {
///         switch self {
///         case .info(let userId):
///             return !userId.isEmpty
///         }
///     }
/// ```
public protocol ModuleRoute: RouteTarget, CustomStringConvertible {
    
    /// Target of route
    var target: ModuleRouteTarget { get }
    
    /// Return false or throw error to stop doing action (show controller or execution some action)
    /// use `ModuleRouteError.unprocessed(reason: String)` to quickly throw an error
    func processible() throws
}

extension ModuleRoute {
    public var description: String {
        target.description
    }
    
    public func processible() throws { }
}

// MARK: - Handle
public extension Router {
    
    @discardableResult static func navigate(to destination: ModuleRoute) -> Bool {
        do {
            switch destination.target {
            case .controller(let controller, let transition):
                try destination.processible()
                try self.transitionChain(controller: controller, transition: transition)
                return true
                
            case .action(let action, let params):
                try destination.processible()
                try action.routeAction(params ?? [:])
                return true
                
            case .actionMapping(let mapping, let params):
                try destination.processible()
                try mapping(params ?? [:])
                return true
                
            case .route(let moduleRoute):
                try destination.processible()
                return Router.navigate(to: moduleRoute)
                
            case .remote(let remoteRoute):
                try destination.processible()
                return Router.handle(route: remoteRoute)
            }
        } catch {
            self.errorForward(error)
            return false
        }
    }
    
}
