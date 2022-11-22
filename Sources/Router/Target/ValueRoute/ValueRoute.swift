//
//  Created by bro on 2022/11/7.
//

import Foundation

/**
 enum PickerRoute {
    case isShowing
 }
 
 extension PickerRoute: ValueRoute {
    var value: Value {
        switch self {
        case .isShowing:
            return CatchValue(get: Picker.shared.isShowing) {
                // `value set` block
            }
        }
    }
 }
 */

public final class Value {
    public typealias GetValueClosure = () throws -> Any?
    public typealias SetValueClosure = (Any?) throws -> Void
    
    private let get: GetValueClosure?
    private let set: SetValueClosure?
    
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
    
    public init(get: GetValueClosure?, set: SetValueClosure? = nil) {
        self.get = get
        self.set = set
    }
    
    public init(get: @autoclosure @escaping GetValueClosure, set: SetValueClosure? = nil) {
        self.get = get
        self.set = set
    }
}

public protocol ValueRoute {
    var value: Value { get }
}

extension Router {
    
    @discardableResult
    public static func value(from: ValueRoute) -> Value {
        from.value
    }
}
