//
//  UIView.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//
import Foundation
import UIKit

extension UIView {
    func setDefaultShadow() {
        setShadow(radius: 3, opacity: 0.5, color: .gray)
        setCornerRadius(radius: 5)
    }
    
    func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func setShadow(radius: CGFloat, opacity: Float, color: UIColor = .gray) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOffset = CGSize.init(width: 0.2, height: 0.8)
            self.layer.shadowRadius = radius
            self.layer.masksToBounds = false
            self.layer.cornerRadius = self.layer.cornerRadius
            self.layer.shadowOpacity = opacity
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        }
    }
    
}
