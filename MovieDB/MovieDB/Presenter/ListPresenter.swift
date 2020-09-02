//
//  ListPresenter.swift
//  MovieDB
//
//  Created by Gabriel Ferreira on 31/08/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import Foundation

class ListPresenter {
    typealias DataListCallBack = (_ dataList: [Movie]?, _ status: Bool, _ message: String) -> Void
    typealias ImageCallBack = (_ imageData: Data?, _ status: Bool, _ message: String) -> Void
    
    var service : ServiceProtocol!
    
    var actualPage : Int = 1
    var pages : Int = 0
    var total : Int = 0
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    init() {
        self.service = Service()
    }
    
    //change the actual page and reload the list
    func changePage(isNext: Bool, callBack: @escaping DataListCallBack) {
        //update actual page and offset
        self.actualPage += isNext ? 1 : -1
        
        //get data from cache or service
        self.getData(callBack: callBack)
    }
    
    //get list from cache or service
    func getData(callBack: @escaping DataListCallBack) {
        //generate a key to try to get from cache
        let key = String(self.actualPage)
        
        //try to get the list from cache or try to get from service
        if let dataList = self.getDataFromCache(key: key) {
            callBack(dataList, true, "")
        } else {
            self.getDataFromService(callBack: callBack)
        }
    }
    
    //get data from cache with a key and a type
    func getDataFromCache(key: String) -> [Movie]? {
        //list of Movies
        var dataList: [Movie]? = nil
        
        //get from cache
        guard let wrapper = Cache.listCache.object(forKey: key as NSString) else { return nil }
        guard let list = wrapper.results else { return nil }
        dataList = list
        
        //return list
        return dataList
    }
    
    //get data from service with a url and a type
    func getDataFromService(callBack: @escaping DataListCallBack){
        do {
            let parameters = ["api_key": apiKey,
                              "page": actualPage,
                              "language": "PT-BR"
                            ] as [String : Any]
            try service.getData(from: apiURL + "movie/now_playing",
                                parameters: parameters,
                                callBack: { [weak self] (serviceData, status, message) in
                if status {
                    guard let data = serviceData else { return }
                    do {
                        print(message)
                        guard let self = self else {return}
                        var dataList: [Movie]
                        
                        let wrapper = try JSONDecoder().decode(Wrapper.self, from: data)
                        guard let list = wrapper.results else {
                            callBack(nil, false, "")
                            return
                        }
                        dataList = list
                        let key = String(self.actualPage)
                        Cache.listCache.setObject(wrapper, forKey: NSString(string: key))
                        
                        self.total = wrapper.total_results ?? 0
                        self.pages = wrapper.total_pages ?? 0
                        callBack(dataList, true, "")
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
}
