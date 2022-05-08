import Foundation

/// Will throw an error when route parse failed
///
/// To catch error with RouteProvider
///
public enum RouteError: Swift.Error, LocalizedError {
    
    /// the `route` is empty (length is zero)
    case empty
    
    /// usually thrown when a route cannot be converted to URLComponents
    case invalid(route: String)
    
    /// usually thrown when scheme or host or path cannot be obtained from URLComponents
    case parseFailure(_ reason: String)
    
    /// usually thrown when route not contains required params
    case missingParams(_ description: String)
    
    case notFound(_ reason: String)
    
    /// usually thrown when custom error
    case error(_ error: Error)
    
    /// custom reason
    case reason(_ reason: String)
    
    public var errorDescription: String? {
        switch self {
        case .empty:
            return "❌ [.empty] The route is empty"
            
        case .invalid(let route):
            return "❌ [.invalid] Invalid route: \(route), can't convert to URL"
            
        case .parseFailure(let reason):
            return "❌ [.parseFailure] Parse route failure: \(reason)"
            
        case .missingParams(let description):
            return "❌ [.missingParams]: \(description)"
            
        case .notFound(let reason):
            return "❌ [.notFound] { \(reason) }"
            
        case .error(let error):
            return "❌ [.error]: \(error.localizedDescription)"
            
        case .reason(let reason):
            return "❌ [.reason] \(reason)"
        }
    }
}
