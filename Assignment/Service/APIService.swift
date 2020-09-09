//
//  APIService.swift
//  Assignment
//
//  Created by Ayan Chakraborty on 07/09/20.
//  Copyright © 2020 Assignment Ayan Chakraborty. All rights reserved.
//

import Foundation

enum RequestType: String {
    case post = "POST" , get = "GET"
}
enum EncodingType {
    case json,urlencoded
}

class APIService: NSObject {
    
    private override init() { }
    
    static let share: APIService = APIService()
    
    private var request:URLRequest?
    
    var httpMethod:RequestType = .post
    
    var encodingType: EncodingType = .urlencoded
    
    private func addToHeader<T: Codable>( header: T){
        let dict =  merger(model: header)
        for (key, value) in dict{
            request?.addValue(StrAny(value), forHTTPHeaderField: key)
        }
    }
    
    func request<T: Codable, U: Codable, V: Codable>(url: String,
                                                     header: V,
                                                     payLoad: T,
                                                     expectedModel: U.Type,
                                                     completionHandler: @escaping (U?,String?) -> ()){
        
        request = URLRequest(url: URL(string: url)!,timeoutInterval: 3)
        addToHeader(header: header)
        request?.httpMethod = httpMethod.rawValue
        
        switch encodingType {
        case .json:
            request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request?.httpBody = try? JSONSerialization.data(withJSONObject: merger(model: payLoad))
        case .urlencoded:
            request?.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request?.httpBody = merger(model: payLoad).map{ $0.0 + "=" + StrAny($0.1) }.joined(separator: "&").data(using: .utf8)
        }
        
        let task = URLSession.shared.dataTask(with: request!) { data, response, error in
            self.request = nil
            guard let data = data else {
                print(String(describing: error.debugDescription))
                completionHandler(nil,error?.localizedDescription)
                return
            }
            do {
                let responseModel = try JSONDecoder().decode(expectedModel.self, from: data)
                print("responseModel", responseModel)
                completionHandler(responseModel,nil)
                
            } catch let DecodingError.dataCorrupted(context) {
                completionHandler(nil,context.debugDescription)
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                completionHandler(nil,context.debugDescription)
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                completionHandler(nil,context.debugDescription)
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                completionHandler(nil,context.debugDescription)
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                completionHandler(nil,error.localizedDescription)
                print("error: ", error)
            }
        }
        
        task.resume()
    }
    
    func merger<T: Codable >(model: T) -> [String: Any] {
        var dictType: [String: Any] = [:]
        do {
            dictType = try JSONSerialization.jsonObject(with: try JSONEncoder().encode(model), options: []) as! [String : Any]
            debugPrint("================ Success Encoding dictonary ================")
            debugPrint("ecoded dictionary data: \(self)")
            debugPrint("===============================")
        } catch let error {
            debugPrint("================ Error Decoding dictonary ================")
            debugPrint("error: \(error.localizedDescription)")
            debugPrint("================")
        }
        return dictType
    }
    
    
}
