//
//  Constants.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import Foundation
import Foundation

struct ViewIdentifiers {
    static let kHomeVC                      = "HomeVC"
}

struct CellIdentifiers {
    static let kImageCell                   = "ImageCell"
}

struct APIPath {
    static let kBaseURL                     = "https://www.flickr.com/services/rest/"
    static let kGetPhotosSearch             = "flickr.photos.search"
}
let kQueueName                              = "com.cache.app"
let kFlickrAPIKey                           = "e6ee178d378488c6f974c38c3ea65b3a"
let kAPIKey                                 = "api_key"
let kFormat                                 = "format"
let kJson                                   = "json"
let kNojsoncallback                         = "nojsoncallback"
let kNoInternetConnection                   = "Please check your internet connection"
let kErrorCreatingEndPoint                  = "Error in creating endpoint"
