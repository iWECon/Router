import Foundation

protocol _RouteParams {
    var aliasNames: [String] { get set }
}
protocol _RouteParamsMapping {
    func mapping(value: String) -> Bool
}

/// When Route initializes a controller, it maps params to params marked as @RouteParams in the controller instance
///
/// ```swift
/// final class UserController: UIViewController {
///     // Set `userName` when route params.keys contains any one(`name` or `nickname`)
///     @RouteParams("name", "nickname") var userName: String = ""
/// }
///
/// // example route:
/// "native://user/info?name=iiiam.in"
/// or
/// "native://user/info?nickname=iiiam.in"
/// ```
@propertyWrapper public class RouteParams<T>: _RouteParams, _RouteParamsMapping {
    var aliasNames: [String]
    var value: T
    public var wrappedValue: T {
        get { value }
        set { value = newValue }
    }
    
    var mapping: ((String) -> T)?
    
    public init(wrappedValue: T, _ aliasNames: String..., mapping: ((String) -> T)? = nil) {
        self.aliasNames = aliasNames
        self.value = wrappedValue
        self.mapping = mapping
    }
    
    func mapping(value: String) -> Bool {
        guard let mapping = mapping else {
            // use built-in mapping
            return false
        }
        // custom mapping
        self.value = mapping(value)
        return true
    }
}

