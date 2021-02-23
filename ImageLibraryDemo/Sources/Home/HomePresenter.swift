//
//  HomePresenter.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import Foundation

class HomePresenter {
    //MARK:- Variables
    var interactor: HomeRequestInteractorProtocol?
    weak var view: HomeViewProtocol?
    var route: HomeRouteProtocol?
    
}

//MARK:- HomePresenterProtocol methods
extension HomePresenter: HomePresenterProtocol {
    func getImageList(inputModel: ImageInputModel) {
        interactor?.getImageList(inputModel: inputModel)
    }
}

//MARK:- HomeResponseInteractorProtocol methods
extension HomePresenter: HomeResponseInteractorProtocol {
    func imagesDidFetch(pages: PageModel) {
        view?.imagesDidFetch(pages: pages)
    }
}
