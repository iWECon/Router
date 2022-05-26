//
//  ConvertTests.swift
//  
//
//  Created by iww on 2022/4/2.
//

import XCTest
@testable import Router

struct ConvertAction: RouteAction {
    static func routeAction(_ params: [String : Any]) throws {
        let group = params["__group"] as? String
        if group != "base" && group != "Base" {
            throw RouteActionError.failure("not base")
        }
        if params["__path"] as? String != "/updateResource" {
            throw RouteActionError.failure("not updateResource")
        }
    }
}

struct ConvertPathRouteProvider: RouteProvider {
    func parseRoute(_ route: String) throws -> ParseInfo? {
        guard route.contains("path=") else {
            return nil
        }
        let components = try RouteComponents(route: route)
        let path = components.queryItems?.filter({ $0.name == "path" }).first?.value
        if path?.contains("/") == true {
            let info = path?.components(separatedBy: "/")
            let group = info?.first ?? ""
            let path = info?.last ?? ""
            let params = components.queryItems?.filter({ $0.name != "path" })
                .filter({ $0.value != nil })
                .map({ ($0.name, $0.value!) }) ?? []
            
            return ParseInfo(route: "native://\(group)/\(path)", params: Dictionary(uniqueKeysWithValues: params))
        }
        return nil
    }
}

struct ConvertModuleActionRouteProvider: RouteProvider {
    func parseRoute(_ route: String) throws -> ParseInfo? {
        guard route.contains("module=") else {
            return nil
        }
        let components = try RouteComponents(route: route)
        let params = components.queryItems?.filter({ $0.value != nil }).map({ ($0.name, $0.value!) }) ?? []
        let dict = Dictionary(uniqueKeysWithValues: params)
        let module = params.filter({ $0.0 == "module" }).first?.1 ?? ""
        let action = params.filter({ $0.0 == "action" }).first?.1 ?? ""
        let finalParams = dict.filter({ $0.key != "module" && $0.key != "action" })
        return ParseInfo(route: "native://\(module)/\(action)", params: finalParams)
    }
}

struct ConvertClassNameRouteProvider: RouteProvider {
    var mapping: [String: String] = [
        "WXMomentsController": "native://community/moments"
    ]
    func parseRoute(_ route: String) throws -> ParseInfo? {
        guard route.contains("className=") else {
            return nil
        }
        let components = try RouteComponents(route: route)
        let params = components.queryItems?.filter({ $0.value != nil }).map({ ($0.name, $0.value!) }) ?? []
        let dict = Dictionary(uniqueKeysWithValues: params)
        let className = params.filter({ $0.0 == "className" }).first?.1 ?? ""
        let finalParams = dict.filter({ $0.key != "className" })
        if let map = mapping[className] {
            return ParseInfo(route: map, params: finalParams)
        }
        return nil
    }
}

class ConvertTests: XCTestCase {
    
    func testConvert1() throws {
        Router.load(mapping: RouteMapping(group: "", maps: [
            .action("base/updateResource?{*resourceId}", target: ConvertAction.self)
        ]))
        Router.provider = ConvertPathRouteProvider()
        let route = "native://?path=base/updateResource&resourceId=10086"
        XCTAssertTrue(Router.handle(route: route))
    }
    
    func testConvert2() throws {
        // native://?module=Base&action=selectTab&identifier=Live
        Router.load(mapping: RouteMapping(group: "", maps: [
            .action("base/updateResource?{*identifier}", target: ConvertAction.self)
        ]))
        Router.provider = ConvertModuleActionRouteProvider()
        let route = "native://?module=Base&action=updateResource&identifier=Live"
        XCTAssertTrue(Router.handle(route: route))
    }
    
    func testConvert3() throws {
        // native://?native://?className=WXMomentsController&userId=10086
        Router.load(mapping: RouteMapping(group: "community", maps: [
            .route("/moments?{*userId}", target: UIViewController.self)
        ]))
        Router.provider = ConvertClassNameRouteProvider()
        let route = "native://?className=WXMomentsController&userId=10086"
        XCTAssertTrue(Router.handle(route: route))
    }

    func testConvert4() throws { // test contains chineses
        Router.load(mapping: RouteMapping(group: "", maps: [
            .action("base/updateResource?{*resourceId}", target: ConvertAction.self)
        ]))
        Router.provider = ConvertPathRouteProvider()
        let route = "native://?path=base/updateResource&resourceId=10086&name=你好啊"
        XCTAssertTrue(Router.handle(route: route))
    }
}
