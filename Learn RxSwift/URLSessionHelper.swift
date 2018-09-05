//
//  NetworkRequest.swift
//  Learn RxSwift
//
//  Created by MTMAC16 on 05/09/18.
//  Copyright © 2018 bism. All rights reserved.
//

import Foundation
import RxSwift

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}

enum requestError: Error {
    case invalidUrl
    case requestFailed
    case invalidResponse
}

extension URLSession {
    func request(url: String, method: HttpMethod, parameters: [String: Any]? = nil, timeout: TimeInterval = 5, completions: @escaping (Data?, URLResponse?, Error?) -> Void) {
        print("url \(url) ")
        guard let urlRequest = URL(string: url) else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: urlRequest, timeoutInterval: timeout)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method.rawValue
        
        if let paramsRequest = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: paramsRequest, options: .prettyPrinted)
            } catch let error as NSError {
                print("failed to parse params to body \(error), \(error.userInfo)")
            }
        }
        
        self.dataTask(with: request, completionHandler: completions).resume()
    }
    
    func request(url: String, method: HttpMethod, parameters: [String: Any]? = nil, timeout: TimeInterval = 5) -> Observable<[String: Any]> {
        print("url \(url)")
        return Observable.create({ (emitter) -> Disposable in
            if let urlRequest = URL(string: url) {
                print("invalid url")
                var request = URLRequest(url: urlRequest, timeoutInterval: timeout)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.httpMethod = method.rawValue
                
                if let paramsRequest = parameters {
                    do {
                        request.httpBody = try JSONSerialization.data(withJSONObject: paramsRequest, options: .prettyPrinted)
                    } catch let error as NSError {
                        print("failed to parse params to body \(error), \(error.userInfo)")
                    }
                }
                
                let task = self.dataTask(with: request, completionHandler: { (data, urlResponse, error) in
                    if let errorResponse = error {
                        emitter.onError(errorResponse)
                    } else if let dataResponse = data {
                        do {
                            let dataJson = try JSONSerialization.jsonObject(with: dataResponse, options: .mutableLeaves)
                            emitter.onNext(dataJson as! [String: Any])
                        } catch let error as NSError {
                            emitter.onError(error)
                            emitter.onCompleted()
                        }
                    } else {
                        emitter.onError(requestError.invalidResponse)
                    }
                    
                    emitter.onCompleted()
                })
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            } else {
                emitter.onError(requestError.invalidUrl)
                emitter.onCompleted()
                return Disposables.create()
            }
        })
        
    }
}
