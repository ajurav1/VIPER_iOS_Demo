//
//  ImageCell.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import UIKit
import Combine

class ImageCell: UICollectionViewCell {
    //MARK:- IBOutlets
    @IBOutlet weak var imgView: UIImageView!
    
    //MARK:- lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = #imageLiteral(resourceName: "defaultImage")
        DownloadManager.shared.cancelAll()
    }
    
    //MARK:- methods
    func update(withImage image: UIImage?) {
        imgView.image = image
    }
}

