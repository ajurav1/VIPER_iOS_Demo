//
//  HomeViewController.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import UIKit

class HomeViewController: UIViewController {
    //MARK:-IBOutlets
    @IBOutlet weak var viewOfCollectionView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewOfSearchText: UIView!
    @IBOutlet weak var lblNoRecordFound: UILabel!
    
    //MARK:- Variables
    var presenter: HomePresenterProtocol?
    let spacing: CGFloat = 5.0
    var photosData: [PhotoModel] = []
    var loadMore: Bool = false
    let footerView = UIActivityIndicatorView(style: .medium)
    private var currentPageIndex = 1
    private var pages: PageModel = PageModel()
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeRoute.createHomeModule(HomeViewRef: self)
        setUpCollectionFlowLayout()
        viewOfCollectionView.setDefaultShadow()
        registerActivityIndicator()
    }
    
    //MARK:-  Methods
    func registerActivityIndicator() {
        collectionView.register(FooterViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: collectionView.bounds.width, height: 50)
        
    }
    func loadMorePhotos() {
        guard let searchText = self.txtSearch.text, searchText.count > 0 else {
            return
        }
        //here we call images from the server as user reached at bottom of the screen
        if !loadMore && self.pages.page ?? 0 < self.pages.pages ?? 0 {
            footerView.startAnimating()
            loadMore = true
            currentPageIndex = self.pages.page! + 1
            getSearchedImages()
        }
    }
    
    //MARK:-  Private Methods
    private func setUpCollectionFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
    }
    
    private func getSearchedImages() {
        //Checking if search text is empty tthen no need to hit api to request Searched iamges
        if let serachText = txtSearch.text, !serachText.isEmpty {
            presenter?.getImageList(inputModel: ImageInputModel(text: serachText, page: "\(currentPageIndex)"))
        } else {
            photosData.removeAll()
            reloadCollectionView()
        }
    }
    
    private func reloadCollectionView() {
        //hide-unhide label in the basis of photos we have in array
        lblNoRecordFound.isHidden = photosData.count > 0 ? true : false
        collectionView.reloadData()
    }
}

//MARK:- UITextFieldDelegate methods
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //In case if cleared the text field then need to cancel downloads if already executing
        guard let searchText = textField.text, searchText.count > 0 else {
            DownloadManager.shared.cancelAll()
            self.photosData.removeAll()
            reloadCollectionView()
            return true
        }
        //If we moved at n pages of the screen then everytime if user search new content. moving him at top position
        if photosData.count > 0 {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        if IndicatorView.isEnabledIndicator {
            IndicatorView.sharedInstance.showIndicator()
        }
        self.getSearchedImages()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        txtSearch.text = ""
        self.view.endEditing(true)
        self.getSearchedImages()
        return false
    }
}

//MARK:- HomeViewProtocol methods
extension HomeViewController: HomeViewProtocol {
    func imagesDidFetch(pages:PageModel) {
        self.pages = pages
        //In case of lazyloading we have to append photos otherwise we can reset the array
        if loadMore == true {
            footerView.stopAnimating()
            photosData.append(contentsOf: pages.photo ?? [])
            loadMore = false
        }else {
            photosData = pages.photo ?? []
        }
        reloadCollectionView()
    }
}
