//
//  Created by bro on 2022/11/7.
//

import Foundation

/**
 
 enum RechargeRoute {
    case isShowing
 }
 
 extension RechargeRoute: ValueRoute {
    var value: Value {
        switch self {
        case .isShowing:
            return CatchValue(get: Recharge.shared.isShowing) {
                // `value set` block
            }
        }
    }
 }
 
 let value: Value = Router.value(from: RechargeRoute.isShowing)
 value.value // `Bool value`
 value.value = false // call `value set` block
 */

public protocol ValueRoute {
    var value: Value { get }
}

public final class Value {
    public typealias Get = () throws -> Any?
    public typealias Set = (Any?) throws -> Void
    
    private let get: Get?
    private let set: Set?
    
    public var value: Any? {
        get {
            do {
                return try get?()
            } catch {
                Router.errorForward(error)
                return nil
            }
        }
        set {
            do {
                try set?(newValue)
            } catch {
                Router.errorForward(error)
            }
        }
    }
    
    public init(get: Get?, set: Set?) {
        self.get = get
        self.set = set
    }
}

extension Router {
    
    @discardableResult
    static func value(from: ValueRoute) -> Value {
        from.value
    }
}
