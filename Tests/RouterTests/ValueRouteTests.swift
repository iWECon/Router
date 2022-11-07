//
//  ValueRouteTests.swift
//  
//
//  Created by bro on 2022/11/7.
//

import XCTest
@testable import Router

final class ValueRouteTestClass {
    
    static let shared = ValueRouteTestClass()
    
    var isShowing = true
}

enum Test {
    case isShowing
}

extension Test: ValueRoute {
    var value: Value {
        switch self {
        case .isShowing:
            return Value {
//                throw ModuleRouteError.unprocessed(reason: "Failed")
                return ValueRouteTestClass.shared.isShowing
            } set: { newValue in
//                throw ModuleRouteError.unprocessed(reason: "set failed")
                ValueRouteTestClass.shared.isShowing = (newValue as? Bool) ?? false
            }
        }
    }
}


final class ValueRouteTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let value = Router.value(from: Test.isShowing)
        guard let isShowing = value.value as? Bool, isShowing else {
            XCTAssertEqual((value.value as? Bool) ?? false, false)
            return
        }
        value.value = false
        XCTAssertEqual(value.value as! Bool, false)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
