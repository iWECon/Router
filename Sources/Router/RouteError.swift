import Foundation

public enum RouteError: Error, LocalizedError {
    case empty
    case invalid(route: String)
    case parseFailure(_ reason: String)
    
    case providerCancel(_ reason: String)
    
    case missingParams(_ description: String)
    
    public var errorDescription: String? {
        switch self {
        case .empty:
            return "❌ The route is empty"
            
        case .invalid(let route):
            return "❌ Invalid route: \(route), can't convert to URL"
            
        case .parseFailure(let reason):
            return "❌ Parse route failure: \(reason)"
            
        case .providerCancel(let reason):
            return "❌ Provider cancnel: \(reason)"
            
        case .missingParams(let description):
            return "❌ Missing params: \(description)"
        }
    }
}
