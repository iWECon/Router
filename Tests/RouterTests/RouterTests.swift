import XCTest
@testable import Router

enum MessageRoute: ModuleRoute {
    case chatUser
    
    var target: ModuleRouteTarget {
        switch self {
        case .chatUser:
            return .controller(UIViewController(), transition: .push)
        }
    }
}

final class CController: UIViewController {
    
    @RouteParams("id", "userId") var userId: String = ""
    @RouteParams("name", "nickname") var nickname: String = ""
    @RouteParams("isSingle", "single") var isSingle: Bool = false
    
    @RouteParams("t", "birthdayTimestamp", mapping: { value in
        (value as NSString).doubleValue
    }) var birthdayTimestamp: TimeInterval = 0
    
    override func didFinishMapping() {
        print("finish mapping: \(userId), \(nickname), \(isSingle), \(birthdayTimestamp)")
    }
}


final class RouterTests: XCTestCase {
    
    func testExample() throws {
        
        let userMapping = MappingInfo(group: "user", maps: [
            .route("/info?{*id/userId}&{*name/nickname}&{*age}", target: CController.self, remark: "user info")
        ])
        Router.load(mappingInfo: userMapping)
        
        XCTAssertFalse(Router.handle(route: "native://user/info?id=10086"))
    }
}


final class UserController: UIViewController {
     // Set `userName` when route params.keys contains any one(`name` or `nickname`)
     @RouteParams("name", "nickname", mapping: { value in
         Date(timeIntervalSince1970: (value as NSString).doubleValue)
     }) var userName: Date = Date()
 }
