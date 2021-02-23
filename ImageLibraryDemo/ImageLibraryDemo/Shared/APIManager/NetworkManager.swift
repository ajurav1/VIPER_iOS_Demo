//
//  NetworkManager.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import Foundation
import SystemConfiguration

enum ReqestType:String{
    case post = "POST"
    case get = "GET"
    case put = "PUT"
}

enum JsonError: String, Error {
    case dataParsingFailed
    case dataModelParsingFailed
    case invalidResponse
    case resultValidationFailed
    case networkNotReachable
    case invalidUrl
    case jsonParsingFailed
    case downloadingFailed
}
extension JsonError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkNotReachable:
            return NSLocalizedString(kNoInternetConnection, comment: "")
            
        case .invalidUrl:
            return NSLocalizedString(kErrorCreatingEndPoint, comment: "")
            
        default:
            return NSLocalizedString("Request Failed", comment: "")
        }
    }
}
extension URLComponents {
    mutating func setFlickrQueryItems(with parameters: [String: String]) {
        var queryItems = [URLQueryItem]()
        let defaultParam = [kAPIKey: kFlickrAPIKey, kFormat: kJson, kNojsoncallback: "1"]
        
        for (key,value) in defaultParam {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        for (key,value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        self.queryItems = queryItems
    }
}

class NetworkUtility {
    typealias ResultData = (_ result: Result<Data, Error>) -> ()
    static let shareInstance = NetworkUtility()
    private init(){}
    
    func callData(requestType: ReqestType , jsonInputData: Data?, query: [String : String]?, completion: @escaping ResultData){
        if isInternetAvailable() {
            let urlPath = APIPath.kBaseURL
            guard var urlComp = URLComponents(string: urlPath) else {
                completion(Result.failure(JsonError.invalidUrl))
                return
            }
            if requestType == .get, let query = query {
                urlComp.setFlickrQueryItems(with: query)
            }
            guard let url = urlComp.url else {
                completion(Result.failure(JsonError.invalidUrl))
                return
            }
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = requestType.rawValue
            if (requestType == .post || requestType == .put) , jsonInputData != nil{
                request.httpBody = jsonInputData!
            }
            URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                do{
                    guard let data = data else{
                        throw JsonError.dataParsingFailed
                    }
                    completion(Result.success(data))
                }
                catch {
                    completion(Result.failure(error))
                }
            }.resume()
        }else{
            completion(Result.failure(JsonError.networkNotReachable))
        }
    }
    
    private func isInternetAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
