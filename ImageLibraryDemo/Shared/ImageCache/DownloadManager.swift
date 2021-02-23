//
//  DownloadManager.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import Foundation
import UIKit

//MARK:- Created ImageDownloadHandler closure
typealias DownloadHandler = (_ image: UIImage?, _ url: URL, _ indexPath: IndexPath?, _ error: Error?) -> Void

final class DownloadManager {
    //MARK:- Variables
    private var completionHandler: DownloadHandler?
    lazy var imageDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = kQueueName
        queue.qualityOfService = .userInteractive
        return queue
    }()
    let imageCache = NSCache<NSString, UIImage>()
    static let shared = DownloadManager()
    
    private init () {}
    
    //MARK:- Methods
    func downloadImage(_ imgURL: String, indexPath: IndexPath?, handler: @escaping DownloadHandler) {
        self.completionHandler = handler
        guard let url = URL(string: imgURL) else {
            return
        }
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            /* check for the cached image for url, if YES then return the cached image */
            print("Return cached Image for \(url)")
           self.completionHandler?(cachedImage, url, indexPath, nil)
        } else {
             /* check if there is a download task that is currently downloading the same image. */
            if let operations = (imageDownloadQueue.operations as? [DownloadOperation])?.filter({$0.imageUrl?.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
                print("Increase the priority for \(url)")
                operation.queuePriority = .veryHigh
            }else {
                /* create a new task to download the image.  */
                print("Create a new task for \(url)")
                let operation = DownloadOperation(url: url, indexPath: indexPath)
                if indexPath == nil {
                    operation.queuePriority = .high
                }
                operation.downloadHandler = { (image, url, indexPath, error) in
                    if let newImage = image {
                        self.imageCache.setObject(newImage, forKey: url.absoluteString as NSString)
                    }
                    self.completionHandler?(image, url, indexPath, error)
                }
                imageDownloadQueue.addOperation(operation)
            }
        }
    }
    
    /* FUNCTION to reduce the priority of the network operation in case the user scrolls and an image is no longer visible. */
    func slowDownImageDownloadTaskfor (_ imgURL: String) {
        guard let url = URL(string: imgURL) else {
            return
        }
        if let operations = (imageDownloadQueue.operations as? [DownloadOperation])?.filter({$0.imageUrl?.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
            print("Reduce the priority for \(url)")
            operation.queuePriority = .low
        }
    }
    
    //If anything runs in asynchronous to download images we can cancel those operations anytime
    func cancelAll() {
        imageDownloadQueue.cancelAllOperations()
    }
}

