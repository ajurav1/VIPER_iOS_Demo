//
//  ImageLibraryDemoTests.swift
//  ImageLibraryDemoTests
//
//  Created by Ajay Kumar on 05/02/21.
//

import XCTest
@testable import ImageLibraryDemo

class ImageLibraryDemoTests: XCTestCase {
    var interactor: HomeInteractor?
    
    override func setUpWithError() throws {
        interactor = HomeInteractor()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testImagesParsing() {
        // 1. given
        let inputImageModel = ImageInputModel(text: "demo", page: "1")
        let getImagesExpectation = expectation(description: "images")
        
        // 2. when
        var photoOutput:ImagesOutputModel?
        interactor?.getImageList(inputModel: inputImageModel) { (result) in
            photoOutput = result
            getImagesExpectation.fulfill()
        }
        
        // 3. then
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertTrue((photoOutput?.photos?.photo!.count)! > 0)
            XCTAssertNotNil(photoOutput?.photos)
        }
    }
}
