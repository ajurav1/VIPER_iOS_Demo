//
//  ImageOperation.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import Foundation
import UIKit

class DownloadOperation: Operation {
    //MARK:- Variables
    var downloadHandler: DownloadHandler?
    var imageUrl:URL?
    private var indexPath: IndexPath?
   
    override var isAsynchronous: Bool {
        get {
            return  true
        }
    }
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
    
    required init (url: URL, indexPath: IndexPath?) {
        self.imageUrl = url
        self.indexPath = indexPath
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        self.executing(true)
        self.downloadImageFromUrl()
    }
    
    func downloadImageFromUrl() {
        let newSession = URLSession.shared
        if let url = self.imageUrl {
            let downloadTask = newSession.downloadTask(with: url) { (location, response, error) in
            if let locationUrl = location, let data = try? Data(contentsOf: locationUrl){
                 let image = UIImage(data: data)
                self.downloadHandler?(image,url, self.indexPath,error)
              }
              self.finish(true)
              self.executing(false)
            }
            downloadTask.resume()
        }
    }
}
