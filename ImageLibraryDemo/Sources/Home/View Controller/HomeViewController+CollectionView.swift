//
//  HomeViewController+CollectionView.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 06/02/21.
//

import UIKit

//MARK:- UICollectionViewDataSource methods
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.kImageCell, for: indexPath) as? ImageCell {
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //Checking for the last index of collection view as scroll reached then send request for more photos
        let lastRowIndex = collectionView.numberOfItems(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            loadMorePhotos()
        }
        
        let photo = photosData[indexPath.row]
        
        //DownloadManager use get downloaded image or cached image
        DownloadManager.shared.downloadImage(getPhotoPath(photo: photo), indexPath: indexPath) { (image, url, indexPath, error) in
            if let indexPathNew = indexPath { //Again matching index after cached or download image that particular cell is showing on screen or not
                DispatchQueue.main.async {
                    //update image in main
                    if let imageCell = collectionView.cellForItem(at: indexPathNew) as? ImageCell {
                        imageCell.update(withImage: image)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /* Reduce the priority of the network operation in case the user scrolls and an image is no longer visible. */
        if self.loadMore {return}
        if photosData.count == 0 {return}
        let flickrPhoto = getPhotoPath(photo: photosData[indexPath.row])
        DownloadManager.shared.slowDownImageDownloadTaskfor(flickrPhoto)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            footer.addSubview(footerView)
            footerView.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
            return footer
        }
        return UICollectionReusableView()
    }
    
    private func getPhotoPath(photo:PhotoModel) -> String {
        let photoPath = "https://farm\(photo.farm ?? 0).staticflickr.com/\(photo.server ?? "")/\(photo.id ?? "")_\(photo.secret ?? "")_m.jpg"
        return photoPath
    }
}

//MARK:- UICollectionViewDelegateFlowLayout methods
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 3
        let spacingBetweenCells:CGFloat = spacing
        
        //here extra spacing is the space which we have to exclude from our screen width
        let extraSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        
        if let collection = self.collectionView{
            //To calculate cell width we have excluded extra spacing and need to divide the total no. of cell
            let width = (collection.bounds.width - extraSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}
