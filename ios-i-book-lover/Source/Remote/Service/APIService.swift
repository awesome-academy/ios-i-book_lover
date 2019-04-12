//
//  APIService.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/11/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import XMLMapper

struct APIService {
    
    static let share = APIService()
    
    private var alamofireManager = Alamofire.SessionManager.default
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
        alamofireManager.adapter = CustomRequestAdapter()
    }
    
    func requestXML<T: XMLMappable>(input: BaseRequest, completion: @escaping ( _ value: T?, _ error: BaseError?) -> Void) {        
        print("\n------------REQUEST INPUT")
        print("link: %@", input.url)
        print("body: %@", input.body ?? "No Body")
        print("------------ END REQUEST INPUT\n")
        
        alamofireManager.request(input.url, method: input.requestType, parameters: input.body, encoding: input.encoding)
            .validate(statusCode: 200..<500)
            .responseString { response in
                print(response.request?.url ?? "Error")
                print(response)
                switch response.result {
                case .success(let value):
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 200 {
                            let object = XMLMapper<T>().map(XMLString: value)
                            completion(object, nil)
                        } else {
                            if let error = XMLMapper<ErrorResponse>().map(XMLfile: value) {
                                completion(nil, BaseError.apiFailure(error: error))
                            } else {
                                completion(nil, BaseError.httpError(httpCode: statusCode))
                            }
                        }
                    } else {
                        completion(nil, BaseError.unexpectedError)
                    }
                case .failure(let error):
                    completion(nil, error as? BaseError)
                }
            }
    }
    
    func requestJSON<T: Mappable>(input: BaseRequest, completion: @escaping ( _ value: T?, _ error: BaseError?) -> Void) {
        print("\n------------REQUEST INPUT")
        print("link: %@", input.url)
        print("body: %@", input.body ?? "No Body")
        print("------------ END REQUEST INPUT\n")
        
        alamofireManager.request(input.url, method: input.requestType, parameters: input.body, encoding: input.encoding)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                print(response.request?.url ?? "Error")
                print(response)
                switch response.result {
                case .success(let value):
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 200 {
                            let object = Mapper<T>().map(JSONObject: value)
                            completion(object, nil)
                        } else {
                            if let error = Mapper<ErrorResponseJSON>().map(JSONObject: value) {
                                completion(nil, BaseError.apiFailureJSON(error: error))
                            } else {
                                completion(nil, BaseError.httpError(httpCode: statusCode))
                            }
                        }
                    } else {
                        completion(nil, BaseError.unexpectedError)
                    }
                case .failure(let error):
                    completion(nil, error as? BaseError)
                }
            }
    }
}
