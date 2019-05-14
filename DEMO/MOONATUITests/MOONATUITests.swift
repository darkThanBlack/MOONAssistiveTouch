//
//  MOONATUITests.swift
//  MOONATUITests
//
//  Created by 徐一丁 on 2019/5/13.
//  Copyright © 2019 月之暗面. All rights reserved.
//

import XCTest

class MOONATUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testATContentView() {
        let app = XCUIApplication()
        
        let window = app.children(matching: .window).matching(identifier: "MOONATT_window").element;
        
        let rootVC = window.otherElements.matching(identifier: "MOONATT_rootvc").element;
        
        let contentView = rootVC.otherElements.matching(identifier: "MOONATT_rootvc_contentview").element;
        
        let menuView = contentView.otherElements.matching(identifier: "MOONATT_rootvc_menuview_0").element
        
//        不要这么写：XCTAssert(window.exists, "视图初始化失败") 存在 NSValue 比较问题  false 不是空
        XCTAssertEqual(window.exists, true)
        XCTAssertEqual(rootVC.exists, true)
        XCTAssertEqual(contentView.exists, true)
        XCTAssertEqual(menuView.exists, true)
        
        XCTAssertEqual(contentView.frame.size, CGSize(width: 65.0, height: 65.0), "关闭状态初始大小错误")
        
        window.tap()
        XCTAssertEqual(contentView.frame.size, CGSize(width: 300.0, height: 300.0), "打开状态大小错误")
        rootVC.tap()
        XCTAssertEqual(contentView.frame.size, CGSize(width: 65.0, height: 65.0), "关闭状态大小错误")

        contentView.tap()
        XCTAssertEqual(contentView.frame.size, CGSize(width: 300.0, height: 300.0), "打开状态大小错误")
        contentView.tap()
        XCTAssertEqual(contentView.frame.size, CGSize(width: 65.0, height: 65.0), "关闭状态大小错误")
        
        contentView.swipeUp()
        contentView.swipeDown()
        contentView.swipeLeft()
        contentView.swipeDown()
        
        
    }
    
    func testATWindow() {        
        let moonattWindowWindow = XCUIApplication().windows["MOONATT_window"]
        let coordinate: XCUICoordinate = moonattWindowWindow.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        coordinate.tap()
        
    }
    
    /// force taps a view if it reports to be not hittable - useful for buttons in cells
    func forceTap(element: XCUIElement) {
        if element.isHittable {
            element.tap()
        } else {
            // You can also try (0, 0)
            let coordinate: XCUICoordinate = element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            coordinate.tap()
        }
    }
}
