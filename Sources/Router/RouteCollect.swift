import Foundation

struct RouteCollect<T> {
    
    private var map: [String: T]
    
    init() {
        self.map = [:]
    }
    
    mutating func merge(values: [String: T]) {
        self.map.merge(values, uniquingKeysWith: { $1 })
    }
    
    subscript (_ key: String) -> T? {
        if self.map.keys.contains(key) {
            return self.map[key]
        }
        if self.map.keys.contains("/" + key) {
            return self.map["/" + key]
        }
        return nil
    }
}

