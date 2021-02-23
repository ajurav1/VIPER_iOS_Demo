//
//  CodableUtility.swift
//  ImageLibraryDemo
//
//  Created by Ajay Kumar on 05/02/21.
//

import Foundation

extension Encodable{
    func getData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func getJsonDictObject() throws -> [String : String]{
        return try JSONSerialization.jsonObject(with: self.getData(), options: .allowFragments) as! [String : String]
    }
}

extension Decodable{
    static func getDataModel(fromData jsonData: Data, completionHandler: (_ result: Result<Self, Error>) -> ()){
        do {
            let apiResponse = try JSONDecoder().decode(Self.self, from: jsonData)
            completionHandler(Result.success(apiResponse))
        } catch {
            print(String(decoding:jsonData, as: UTF8.self))
            AppUtility.showAlert(title: "API Error", subtitle:"Unable to Parse below json\n\n" + String(decoding:jsonData, as: UTF8.self))
            completionHandler(Result.failure(error))
        }
    }
}
