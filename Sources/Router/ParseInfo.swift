//
//  Created by iww on 2022/4/2.
//

import Foundation

public struct ParseInfo {
    public let route: String
    public let params: [String: String]
    
    public init(route: String, params: [String: String]) {
        self.route = route
        self.params = params
    }
    
    var _route: String {
        let query = params.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
        return "\(route)?\(query)"
    }
}
