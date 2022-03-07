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

final class RouterTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        // native://user/info?{*id/userId}
        let userRoute = MappingInfo(group: "user", maps: [
            .route("/info?{*id/userId}", target: UIViewController.self, remark: "user info")
        ])
        
        Router.load(routeInfo: userRoute)
        
        //Router.handle(moduleRoute: MessageRoute.chatUser)
        Router.handle(route: "native://user/info")
    }
}
