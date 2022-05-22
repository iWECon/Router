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
    
    struct User {
        let name: String
    }
    
    @RouteParams("id") var userId: String = ""
    @RouteParams("nickname", "name") var nickname: String = ""
    @RouteParams var user: User?
    
    override func routeParamsMappingDidFinish() {
        print("finish mapping with userId: \(userId)")
        print("finish mapping with user.name: \(user?.name ?? "NOT FOUND")")
    }
}

struct BaseActions: RouteAction {
    static func routeAction(_ params: [String: Any]) throws {
        
    }
}

final class RouterTests: XCTestCase {
    
    func testExample() throws {
        
        let userMapping = RouteMapping(group: "user", maps: [
            .route("/info?{*id/userId}", target: UserController.self),
            .route("/account?{*id/userId}", target: UIViewController.self),
            
            // actions
            .action("/updateResources", target: BaseActions.self),
            .action("/action?{*name}", target: BaseActions.self),
            
            .actionMapping("/throwAnError?{*id}", action: { params in
                print("throwAnError bcz not `id`", params)
            }),
            .actionMapping("/thatsFine", action: { params in
                print("fine", params)
            }),
        ])
        Router.load(mapping: userMapping)
        
        XCTAssertTrue(Router.handle(route: "native://user/info?id=10086"))
        XCTAssertTrue(Router.handle(route: "native://user/info?userId=10089"))
        
        // missing required params id or userId
        XCTAssertFalse(Router.handle(route: "native://user/info"))
        
        XCTAssertTrue(Router.handle(route: "native://user/updateResources"))
        
        XCTAssertFalse(Router.handle(route: "native://user/throwAnError"))
        XCTAssertTrue(Router.handle(route: "native://user/thatsFine?ok=200"))
        
        // action name error
        XCTAssertFalse(Router.handle(route: "native://user/action"))
        XCTAssertTrue(Router.handle(route: "native://user/action?name=update"))
        
        Router.navigate(to: MessageRoute.chatUser)
        
        print(Router.description)
    }
    
    func testMappingStruct() throws {
        let controller = UserController()
        controller.routeParamsMappingProcess(["user": UserController.User(name: "Hello~"), "id": "1824"])
        controller.routeParamsMappingDidFinish()
        
        XCTAssertEqual("Hello~", controller.user?.name)
        XCTAssertEqual("1824", controller.userId)
    }
}
