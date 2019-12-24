//
//  RestClient.swift
//  DailyFeed
//
//  Created by Admin on 10/23/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

typealias JSON = [String: Any]

extension String: Error {} // Enables you to throw a string

extension String: LocalizedError { // Adds error.localizedDescription to Error instances
    public var errorDescription: String? { return self }
}

class RestClient {
    
    var baseUrl: String
    var defaultHeader: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
    
    init(baseUrl: BaseURL) {
        self.baseUrl = baseUrl.rawValue
    }
    
    public func request<T: Decodable>(_ resourceUrl: URL?) -> Promise<T> {
        return Promise { seal in
            
            guard let url = resourceUrl else { seal.reject(JSONDecodingError.unknownError); return }
            
            if !Reach().isNetworkConnected() {
                let error = NetworkError.NO_INTERNET_CONNECTION.rawValue
                seal.reject(error)
                return
            }
            
            Alamofire.request(url).responseJSON(completionHandler: { (data) in
                switch data.result {
                case .success(let json):
                    guard data.error == nil else{
                        seal.reject(data.error!)
                        return
                    }
                    
                    guard let dataResponse = data.data else{
                        seal.reject(data.error!)
                        return
                    }
                    
                    do {
                        let jsonFromData =  try JSONDecoder().decode(T.self, from: dataResponse)
                        seal.fulfill(jsonFromData)
                    } catch DecodingError.dataCorrupted(let context) {
                        seal.reject(DecodingError.dataCorrupted(context))
                    } catch DecodingError.keyNotFound(let key, let context) {
                        seal.reject(DecodingError.keyNotFound(key, context))
                    } catch DecodingError.typeMismatch(let type, let context) {
                        seal.reject(DecodingError.typeMismatch(type, context))
                    } catch DecodingError.valueNotFound(let value, let context) {
                        seal.reject(DecodingError.valueNotFound(value, context))
                    } catch {
                        seal.reject(JSONDecodingError.unknownError)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            })
        }
        
    }
    
}
