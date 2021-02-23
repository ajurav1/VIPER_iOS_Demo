//
//  HomeEntity.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import Foundation

// Data Model to get images from API
struct ImageInputModel: Encodable {
    var text: String?
    var perpage = "30"
    var page: String?
    var method = APIPath.kGetPhotosSearch
    
    init(text: String, page: String) {
        self.text = text
        self.page = page
    }
    
    enum CodingKeys: String, CodingKey {
        case perpage = "per_page"
        case text
        case page
        case method
    }
}

// Output image Data Model received from API
struct ImagesOutputModel: Decodable {
    var photos: PageModel?
}

struct PageModel: Decodable {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var photo: [PhotoModel]?
}

struct PhotoModel: Decodable {
    var id: String?
    var owner: String?
    var secret: String?
    var farm: Int?
    var server: String?
    var title: String?
}

