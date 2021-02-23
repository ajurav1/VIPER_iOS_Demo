//
//  AppUtility.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import Foundation
import UIKit

class AppUtility{
    static func showAlert(_ error: Error){
        self.showAlert(title: "Error", subtitle: error.localizedDescription)
    }
    
    static func showAlert(title: String, subtitle: String){
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: subtitle, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        })
    }
}
