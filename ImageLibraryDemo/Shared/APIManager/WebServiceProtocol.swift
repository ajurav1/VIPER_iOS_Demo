//
//  WebServiceProtocol.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import Foundation

protocol WebServiceProtocol {
    associatedtype DataModel: Decodable   // return data type
    typealias ResultData = (_ result: Result<DataModel, Error>) -> ()
    typealias ErrorData = (_ error: Error?) -> ()
    
    var inputDataModel: Encodable? { get set }  // input params data
    
    func callAPI(ofRequestType requestType: ReqestType, completionHandler: @escaping ResultData)
}

extension WebServiceProtocol{
    func callAPI(ofRequestType requestType: ReqestType, completionHandler: @escaping ResultData){
        do{
            var inputData: Data?
            var inputQuery:  [String : String]?
            //encode model
            if let inputModel = inputDataModel{
                if requestType == .get{
                    inputQuery = try inputModel.getJsonDictObject()
                } else{
                    inputData = try inputModel.getData()
                }
            }
            //call network API
            DispatchQueue.global(qos: .background).async {
                NetworkUtility.shareInstance.callData(requestType: requestType, jsonInputData: inputData, query: inputQuery) { (result) in
                    DispatchQueue.main.async {
                        switch result{
                        case .success(let data):
                            //decode data to model
                            DataModel.getDataModel(fromData: data, completionHandler: { (result) in
                                completionHandler(result)
                            })
                        case .failure(let error):
                            completionHandler(Result.failure(error))
                        }
                    }
                }
            }
        }
        catch {
            completionHandler(Result.failure(error))
        }
    }
}
