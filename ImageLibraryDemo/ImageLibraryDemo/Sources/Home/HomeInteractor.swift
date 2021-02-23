//
//  HomeInteractor.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import Foundation

class HomeInteractor: WebServiceProtocol {
    typealias DataModel = ImagesOutputModel
    var inputDataModel: Encodable?
    
    //MARK:- Variables
    weak var presenter: HomeResponseInteractorProtocol?
    
    //MARK:- Methods
    func getImageList(inputModel: ImageInputModel, completionHandler: @escaping (_ result: ImagesOutputModel?) -> ()) {
        self.inputDataModel = inputModel
        // calling WebServiceProtocol methods to get data from API
        self.callAPI(ofRequestType: .get) { (result) in
            DispatchQueue.main.async {
                if IndicatorView.isEnabledIndicator {
                    IndicatorView.sharedInstance.hideIndicator()
                }
                switch result{
                case .success(let apiResponse):
                    completionHandler(apiResponse)
                case .failure(let error):
                    completionHandler(nil)
                    AppUtility.showAlert(error)
                }
            }
        }
    }
}

//MARK:- HomeRequestInteractorProtocol methods
extension HomeInteractor: HomeRequestInteractorProtocol {
    func getImageList(inputModel: ImageInputModel) {
        getImageList(inputModel: inputModel) { (result) in
            if let photoOutput = result {
                self.presenter?.imagesDidFetch(pages: photoOutput.photos ?? PageModel(page: 0, pages: 0, perpage: 0, photo: []))
            }
        }
    }
}
