//
//  ImageLibraryDemoUITests.swift
//  ImageLibraryDemoUITests
//
//  Created by Ajay Kumar on 05/02/21.
//

import XCTest

class ImageLibraryDemoUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchImageFeature() {
        let app = XCUIApplication()
        app.launch()
        
        // 1. given
        app.textFields["Search Image"].tap()
        app.textFields["Search Image"].typeText("demo")
        
        // 2. when
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(10)
        app.swipeUp()
        sleep(2)
        
        // 3. then
        XCTAssert(app.collectionViews.cells.count > 0)
    }
    
}

