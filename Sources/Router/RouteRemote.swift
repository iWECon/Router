import Foundation

public struct RouteRemote: Codable {
    
    public struct Info: Codable {
        public let group: String
        public let path: String
        public let targetName: String
    }
    
    public let routes: [Info]
    public let actions: [Info]
}
