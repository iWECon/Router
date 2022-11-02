//
//  Created by bro on 2022/11/2.
//

import Foundation
import UIKit

public protocol RouteMapTargetController {
    init()
}

public typealias RouteMapTargetControllerProvider = RouteMapTargetController & UIViewController
