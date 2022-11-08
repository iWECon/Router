//
//  Created by iww on 2022/5/13.
//

import Foundation

// MARK: RouteModuleError
public enum ModuleRouteError: Swift.Error, LocalizedError, CustomStringConvertible {
    
    case unprocessed(reason: String)
    
    case invalid(reason: String?)
    
    public var errorDescription: String? {
        switch self {
        case .unprocessed(let reason):
            return "unprocessed: \(reason)"
            
        case .invalid(let reason):
            return "invalid: \(reason ?? "")"
        }
    }
    
    public var description: String {
        errorDescription!
    }
}
