//
//  MoviePresenter.swift
//  MovieDB
//
//  Created by Gabriel Ferreira on 31/08/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import Foundation

class MoviePresenter {
    typealias MovieCallBack = (_ movie: Movie?, _ status: Bool, _ message: String) -> Void
    typealias ImageCallBack = (_ poster: Data?, _ status: Bool, _ message: String) -> Void
    typealias PeopleCallBack = (_ credit: CreditsWrapper?, _ status: Bool, _ message: String) -> Void
    
    var service : ServiceProtocol!
    var url: String!
    var peopleUrl: String?
    
    init(url: String, service: ServiceProtocol) {
        self.service = service
        self.url = url
    }
    
    init(url: String) {
        self.service = Service()
        self.url = url
    }
    
    //get movie from cache or service
    func getData(callBack: @escaping MovieCallBack) {
        //generate a key to try to get from cache
        let key: String = self.url
        
        //try to get the list from cache or try to get from service
        if let movie = self.getDataFromCache(key: key) {
            callBack(movie, true, "")
        } else {
            self.getDataFromService(callBack: callBack)
        }
    }
    
    //get data from cache with a key and a type
    func getDataFromCache(key: String) -> Movie? {
        //get from cache
        guard let movie = Cache.movieCache.object(forKey: key as NSString) else { return nil }
        
        //return list
        return movie
    }
    
    //get data from service with a url and a type
    func getDataFromService(callBack: @escaping MovieCallBack){
        do {
            let parameters = ["api_key": apiKey,
                              "language": "PT-BR"
                            ] as [String : Any]

            try service.getData(from: self.url,
                                parameters: parameters,
                                callBack: { [weak self] (serviceData, status, message) in
                if status {
                    guard let data = serviceData else { return }
                    do {
                        print(message)
                        guard let self = self else {return}
                        let movie = try JSONDecoder().decode(Movie.self, from: data)
                        let key: String = self.url
                        Cache.movieCache.setObject(movie, forKey: NSString(string: key))
                        
                        callBack(movie, true, "")
                    } catch {
                        print(error)
                    }
                } else {
                    print(message, self.debugDescription)
                    callBack(nil, false, message)
                }
            })
        }catch ConnectErrors.receivedFailure{
            callBack(nil, false, "Lack of internet connection")
        }catch{
            callBack(nil, false, error.localizedDescription)
        }
    }
    
    func getImage(from url: String, callBack: @escaping ImageCallBack) {
        //try to get the image from cache or try to get from service
        if let imageData = self.getImageFromCache(key: url) {
            callBack(imageData, true, "")
        } else {
            self.getImageFromService(from: url, callBack: callBack)
        }
    }
    
    func getImageFromCache(key: String) -> Data? {
        //data of image
        var data: Data? = nil
        
        //get image data from cache
        guard let nsData = Cache.imageCache.object(forKey: key as NSString) else { return nil }
        data = nsData as Data
        
        return data
    }
    
    func getImageFromService(from url: String, callBack: @escaping ImageCallBack) {
        do {
            try self.service.getData(from: url, parameters: nil) { (data, status, message) in
                if status {
                    if let imageData = data {
                        Cache.imageCache.setObject(imageData as NSData, forKey: NSString(string: url))
                    }
                }
                callBack(data, status, message)
            }
        } catch ConnectErrors.receivedFailure{
            callBack(nil, false, "Lack of internet connection")
        }catch{
            callBack(nil, false, error.localizedDescription)
        }
    }
    
    //get movie from cache or service
    func getPeopleData(callBack: @escaping PeopleCallBack) {
        guard let url = self.peopleUrl else { return }
        //generate a key to try to get from cache
        let key: String = url
        
        //try to get the list from cache or try to get from service
        if let credit = self.getPeopleDataFromCache(key: key) {
            callBack(credit, true, "")
        } else {
            self.getPeopleDataFromService(url: url, callBack: callBack)
        }
    }
    
    //get data from cache with a key and a type
    func getPeopleDataFromCache(key: String) -> CreditsWrapper? {
        //get from cache
        guard let credits = Cache.peopleCache.object(forKey: key as NSString) else { return nil }
        
        //return list
        return credits
    }
    
    //get data from service with a url and a type
    func getPeopleDataFromService(url: String, callBack: @escaping PeopleCallBack){
        do {
            let parameters = ["api_key": apiKey,
                              "language": "PT-BR"
                            ] as [String : Any]

            try service.getData(from: apiURL + url,
                                parameters: parameters,
                                callBack: { [weak self] (serviceData, status, message) in
                if status {
                    guard let data = serviceData else { return }
                    do {
                        print(message)
                        guard let self = self else {return}
                        let credits = try JSONDecoder().decode(CreditsWrapper.self, from: data)
                        let key: String = self.url
                        Cache.peopleCache.setObject(credits, forKey: NSString(string: key))
                        
                        callBack(credits, true, "")
                    } catch {
                        print(error)
                    }
                } else {
                    print(message, self.debugDescription)
                    callBack(nil, false, message)
                }
            })
        }catch ConnectErrors.receivedFailure{
            callBack(nil, false, "Lack of internet connection")
        }catch{
            callBack(nil, false, error.localizedDescription)
        }
    }
}
