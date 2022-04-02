import Foundation

protocol _RouteParams {
    var aliasNames: [String]? { get set }
}
protocol _RouteParamsMapping {
    func mapping(value: Any) -> Bool
}

/// When Route initializes a controller, it maps params to params marked as @RouteParams in the controller.
///
/// The type of support has: String(?), Int(?), Int32(?), Int64(?), Float(?), Double(?), CGFloat(?), Bool(?)
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
    
    func mapping(value: Any) -> Bool {
        guard let mapping = mapping else {
            // use built-in mapping
            return false
        }
        // custom mapping
        self.value = mapping(value)
        return true
    }
}
