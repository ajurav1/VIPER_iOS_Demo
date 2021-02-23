//
//  HomeProtocol.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import Foundation

//MARK:- PRESENTER -> VIEW
protocol HomeViewProtocol: class {
    func imagesDidFetch(pages: PageModel)
}

//MARK:- PRESENTER -> INTERACTOR
protocol HomeRequestInteractorProtocol: class {
    var presenter: HomeResponseInteractorProtocol? {get set}
    func getImageList(inputModel: ImageInputModel)
}

//MARK:- VIEW -> PRESENTER
protocol HomePresenterProtocol: class {
    var interactor: HomeRequestInteractorProtocol? {set get}
    var route: HomeRouteProtocol? {get set}
    var view: HomeViewProtocol? {get set}
    func getImageList(inputModel: ImageInputModel)
}

//MARK:- INTERACTOR -> PRESENTER
protocol HomeResponseInteractorProtocol: class {
    func imagesDidFetch(pages: PageModel)
}

//MARK:- PRESENTER -> ROUTE
protocol HomeRouteProtocol: class { }
