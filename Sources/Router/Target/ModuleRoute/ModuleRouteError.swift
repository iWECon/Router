//
//  Created by iww on 2022/5/13.
//

import Foundation

// MARK: RouteModuleError
public enum ModuleRouteError: Swift.Error, LocalizedError, CustomStringConvertible {
    case unprocessed(reason: String)
    
    public var errorDescription: String? {
        switch self {
        case .unprocessed(let reason):
            return "unprocessed: \(reason)"
        }
    }
    
    public var description: String {
        errorDescription!
    }
}
