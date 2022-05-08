//
//  Created by i on 2022/5/8.
//

import Foundation

struct RouteLogger {
    let category: String
    
    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let newMessage = makeMessage("[DEBUG] \(message)", file: file, function: function, line: line)
        _print(newMessage)
    }
    
    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let newMessage = makeMessage("[WARNING] \(message)", file: file, function: function, line: line)
        _print(newMessage)
    }
    
    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let newMessage = makeMessage("[ERROR] \(message)", file: file, function: function, line: line)
        _print(newMessage)
    }
    
    private func makeMessage(_ message: String, file: String = #file, function: String = #function, line: Int = #line) -> String {
        "[\(category)] \(message) [\(file):\(function)#\(line)]"
    }
    
    private func _print(_ message: String) {
        assert({ print(message); return true; }())
    }
}

let logger = RouteLogger(category: "Router")
