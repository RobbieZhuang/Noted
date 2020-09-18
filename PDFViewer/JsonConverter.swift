//
// AlamofireViewModel.swift
// BagIt
//
// Created by Robbie Zhuang on 2018-01-28.
// Copyright © 2018 bagit. All rights reserved.
//

import Foundation

class JsonConverter: NSObject {
    
    /**
     
     Convert data to json
     
     - Parameter data: Data type which contains string of json
     
     */
    func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    /**
     
     Convert json to data
     
     - Parameter data: json containing all required data
     
     */
    func jsonToData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}
