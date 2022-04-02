import XCTest
@testable import Router

enum MessageRoute: ModuleRoute {
    case chatUser
    
    var target: ModuleRouteTarget {
        switch self {
        case .chatUser:
            return .controller(UIViewController(), transition: .push())
        }
    }
}

final class UserController: UIViewController {
    
    @RouteParams("id", "userId") var userId: String = ""
    
    @RouteParams("name") var nickname: String? = nil
    
    override func routeParamsMappingDidFinish() {
        print("finish mapping with userId: \(userId)")
    }
}

struct BaseActions: RouteAction {
    static func routeAction(_ params: [String: Any]) -> Bool {
        return true
    }
}

final class RouterTests: XCTestCase {
    
    func testExample() throws {
        
        let userMapping = RouteMapping(group: "user", maps: [
            .route("/info?{*id/userId}", target: UserController.self),
            .route("/account?{*id/userId}", target: UIViewController.self),
            
            // actions
            .action("/updateResources", target: BaseActions.self)
        ])
        Router.load(mapping: userMapping)
        
        XCTAssertTrue(Router.handle(route: "native://user/info?id=10086"))
        XCTAssertTrue(Router.handle(route: "native://user/info?userId=10089"))
        
        // missing required params id or userId
        XCTAssertFalse(Router.handle(route: "native://user/info"))
        
        XCTAssertTrue(Router.handle(route: "native://user/updateResources"))
        
        Router.navigate(to: MessageRoute.chatUser)
        
        print(Router.description)
    }
}
