import Foundation

protocol _RouteParams {
    var aliasNames: [String]? { get set }
}
protocol _RouteParamsMapping {
    func mapping(value: Any)
}

/// When Route initializes a controller, it maps params to params marked as @RouteParams in the controller.
///
/// The type of support has: String(?), Int(?), Int32(?), Int64(?), UInt(?), UInt32(?), UInt64(?), Float(?), Double(?), CGFloat(?), Bool(?)
///
/// You can also customize mappings.
///
/// Customize example:
///
/// ```swift
///final class UserController: UIViewController {
///     // Set `userName` when route params.keys contains anyone(`t` or `birthday`)
///     @RouteParams("t", "birthday", mapping: { value in
///         Date(timeIntervalSince1970: (value as NSString).doubleValue)
///     }) var birthday: Date = Date()
/// }
/// ```
///
/// Use example:
///
/// ```swift
/// final class UserController: UIViewController {
///     // Set `userName` when route params.keys contains anyone(`name` or `nickname`)
///     //
///     // ⚠️: If your wanna use custom alias names, your must set a default value for the property,
///     //     otherwish xcode will show error tips: `missing argument label 'wrappedValue:' in call`.
///     //
///     // You can ignore the default value without using a custom alias.
///     // Like this: @RouteParams var userName: String?
///     //
///     @RouteParams("name", "nickname") var userName: String = ""
/// }
///
/// // example route:
/// "native://user/info?name=iiiam.in"
/// or
/// "native://user/info?nickname=iiiam.in"
/// ```
@propertyWrapper public class RouteParams<T>: _RouteParams, _RouteParamsMapping {
    var aliasNames: [String]?
    var value: T
    public var wrappedValue: T {
        get { value }
        set { value = newValue }
    }
    
    var mapping: ((Any) -> T)?
    
    public init(wrappedValue: T) {
        self.value = wrappedValue
    }
    
    public init(wrappedValue: T, mapping: ((Any) -> T)? = nil) {
        self.value = wrappedValue
        self.mapping = mapping
    }
    
    public init(wrappedValue: T, _ aliasNames: String..., mapping: ((Any) -> T)? = nil) {
        self.aliasNames = aliasNames
        self.value = wrappedValue
        self.mapping = mapping
    }
    
    public init(wrappedValue: T, _ aliasNames: [String], mapping: ((Any) -> T)? = nil) {
        self.aliasNames = aliasNames
        self.value = wrappedValue
        self.mapping = mapping
    }
    
    /// value convert
    internal func mapping(value: Any) {
        if let mapping = mapping { // custom mapping
            self.value = mapping(value)
            return
        }
        if _castToGenericMapping(value: value) {
            return
        }
        
        // notice error
        logger.error("❌ [RouteParams] Cannot conver value of type `\(type(of: value.self))` to specified type `\(T.self)`, you can try use `mapping` to implemented mapping through for yourself.")
    }
    
    /// convert value to generic type
    internal func _castToGenericMapping(value: Any) -> Bool {
        if let t = value as? T {
            self.value = t
            return true
        }
        return false
    }
}
