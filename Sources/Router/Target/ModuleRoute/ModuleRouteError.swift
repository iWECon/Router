//
//  Created by iww on 2022/5/13.
//

import Foundation

// MARK: RouteModuleError
public enum ModuleRouteError: Swift.Error, LocalizedError {
    case unprocessed(reason: String)
}
