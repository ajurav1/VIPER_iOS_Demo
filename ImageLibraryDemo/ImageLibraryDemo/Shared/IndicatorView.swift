//
//  IndicatorView.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import UIKit

public class IndicatorView {
    public static let sharedInstance = IndicatorView()
    var blurImg = UIImageView()
    var indicator = UIActivityIndicatorView()
    static var isEnabledIndicator = true
    
    private init() {
        blurImg.frame = UIScreen.main.bounds
        blurImg.backgroundColor = UIColor.black
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha = 0.5
        indicator.style = .large
        indicator.center = blurImg.center
        indicator.startAnimating()
        indicator.color = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func showIndicator(){
        DispatchQueue.main.async( execute: {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            keyWindow?.addSubview(self.blurImg)
            keyWindow?.addSubview(self.indicator)
        })
    }
    func hideIndicator(){
        DispatchQueue.main.async( execute: {
            self.blurImg.removeFromSuperview()
            self.indicator.removeFromSuperview()
        })
    }
}
