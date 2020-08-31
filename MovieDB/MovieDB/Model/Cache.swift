//
//  Cache.swift
//  MovieDB
//
//  Created by Gabriel Ferreira on 31/08/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import Foundation

struct Cache {
    static let imageCache = NSCache<NSString, NSData>()
    
//    static func getKey(type: DataType, offset: Int, limit: Int) -> String {
//        let key = type.string() + String(offset) + "/" + String(limit)
//        return key
//    }
}
