//
//  HomeRoute.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import Foundation
import UIKit

class HomeRoute: HomeRouteProtocol {
    //MARK:- variables
    weak var presenter: HomePresenter?
    weak var navigationController: UINavigationController?
    
    //MARK:- methods
    //setting reference for Home module
    static func createHomeModule(HomeViewRef: HomeViewController) {
        let presenter: HomePresenterProtocol & HomeResponseInteractorProtocol = HomePresenter()
        
        let router = HomeRoute()
        HomeViewRef.presenter = presenter
        HomeViewRef.presenter?.route = router
        HomeViewRef.presenter?.view = HomeViewRef
        HomeViewRef.presenter?.interactor = HomeInteractor()
        HomeViewRef.presenter?.interactor?.presenter = presenter
        
        router.navigationController = HomeViewRef.navigationController
        router.presenter = presenter as? HomePresenter
    }
}
