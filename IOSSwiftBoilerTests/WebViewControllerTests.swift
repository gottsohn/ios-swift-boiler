//
//  WebViewControllerTests.swift
//  IOSSwiftBoiler
//
//  Created by Godson Ukpere on 3/17/16.
//  Copyright © 2016 Godson Ukpere. All rights reserved.
//

import XCTest
@testable import IOSSwiftBoiler

class WebViewControllerTests: XCTestCase {
    
    var webViewController:WebViewController!
    var timer:NSTimer!
    var asyncExpectation:XCTestExpectation!
    override func setUp() {
        super.setUp()
        webViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(Const.ID_WEB_VIEW_CONTROLLER) as! WebViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        webViewController = nil
        super.tearDown()
    }
    
    func testViews() {
        XCTAssertNil(webViewController.webView)
        XCTAssertNil(webViewController.progressView)
    
        _ = webViewController.view
        
        XCTAssertNotNil(webViewController.webView)
        XCTAssertNotNil(webViewController.progressView)
    }
    
    func testWebViewNoLoad() {
        XCTAssertNil(webViewController.url)
        XCTAssertNil(webViewController.labelText)
    
        _ = webViewController.view
        
        
        XCTAssertEqual(webViewController.progressView.progress, 0.0)
    }
    
    func testWebViewLoad() {
        asyncExpectation = expectationWithDescription("server responded")
        XCTAssertNil(webViewController.url)
        XCTAssertNil(webViewController.labelText)
        
        webViewController.url = "http://blog.godson.com.ng"
        _ = webViewController.view
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "checkProgress", userInfo: nil, repeats: false)
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func checkProgress() {
        XCTAssertNotNil(webViewController.progressView)
        XCTAssert(webViewController.progressView.hidden, "Progress View should be hidden")
        XCTAssertGreaterThan(webViewController.progressView.progress, 0.9)
        timer.invalidate()
        asyncExpectation.fulfill()
    }
    
    

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
