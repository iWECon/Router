import Foundation

/// Will throw an error when route parse failed
///
/// To catch error with RouteProvider
///
public enum RouteError: Error, LocalizedError {
    
    /// the `route` is empty (length is zero)
    case empty
    
    /// usually thrown when a route cannot be converted to URLComponents
    case invalid(route: String)
    
    /// usually thrown when scheme or host or path cannot be obtained from URLComponents
    case parseFailure(_ reason: String)
    
    /// usually thrown when RouteProvider.pocessible return false
    case providerReject(_ reason: String)
    
    /// usually thrown when route not contains required params
    case missingParams(_ description: String)
    
    /// usually thrown when custom error
    case error(Error)
    
    public var errorDescription: String? {
        switch self {
        case .empty:
            return "❌ The route is empty"
            
        case .invalid(let route):
            return "❌ Invalid route: \(route), can't convert to URL"
            
        case .parseFailure(let reason):
            return "❌ Parse route failure: \(reason)"
            
        case .providerReject(let reason):
            return "❌ Provider rejected: \(reason)"
            
        case .missingParams(let description):
            return "❌ Missing params: \(description)"
            
        case .error(let error):
            return "❌ Custom error: \(error.localizedDescription)"
        }
    }
}
