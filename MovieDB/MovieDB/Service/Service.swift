//
//  Service.swift
//  MovieDB
//
//  Created by Gabriel Ferreira on 31/08/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import Foundation
import Alamofire

class Service : ServiceProtocol {
    func getData(from url: String, parameters: Parameters?, callBack: @escaping CallBack) throws {
        guard NetworkReachabilityManager()?.isReachable ?? false else {
            throw ConnectErrors.receivedFailure
        }
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
            (responseData) in
            switch responseData.result {
            case .failure(let error):
                callBack(nil, false, error.errorDescription ?? "")
            case .success(_):
                guard let data = responseData.data else {
                    callBack(nil, false, "API response did not return data")
                    return
                }
                
                do {
                    if responseData.response?.statusCode == 200 {
                        callBack(data, true, "")
                    } else {
                        let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                        callBack(nil, false, errorMessage.status)
                    }
                } catch {
                    callBack(nil, false, error.localizedDescription)
                }
            }
        }
    }
}
