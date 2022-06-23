//
//  Created by iww on 2022/5/26.
//

import Foundation

public struct RouteComponents {
    
    let originalRoute: String
    let encodingRoute: String?
    
    let urlComponents: URLComponents
    
    public init(route: String) throws {
        
        self.originalRoute = route
        // when `addingPercentEncoding(withAllowedCharacters:)` return nil, read this: https://stackoverflow.com/a/33558934
        self.encodingRoute = route.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let urlComponents = URLComponents(string: encodingRoute ?? originalRoute) else {
            let extraMessage: String = encodingRoute == nil ? " encoding failed, find more help: https://stackoverflow.com/a/33558934" : ""
            throw RouteError.reason("Can't convert \(route) to `URLComponents`.\(extraMessage)")
        }
        self.urlComponents = urlComponents
    }
    
    public var scheme: String? {
        urlComponents.scheme
    }
    public var host: String? {
        urlComponents.host
    }
    public var path: String {
        urlComponents.path
    }
    public var query: String? {
        urlComponents.query
    }
    public var queryItems: [URLQueryItem]? {
        urlComponents.queryItems
    }
}
