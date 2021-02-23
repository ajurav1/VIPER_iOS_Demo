//
//  UIApplication.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import Foundation
import UIKit

extension UIApplication {
    // To get top view controller of our view hierarchy
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        return viewController
    }
}

