//
//  ServiceProtocol.swift
//  MovieDB
//
//  Created by Gabriel Ferreira on 31/08/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import Foundation
import Alamofire

protocol ServiceProtocol {
    typealias CallBack = (_ data: Data?, _ status: Bool, _ message:String) -> Void
    
    func getData(from url: String, parameters: Parameters?, callBack: @escaping CallBack) throws
}
