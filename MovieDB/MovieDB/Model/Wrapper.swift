//
//  Wrapper.swift
//  MovieDB
//
//  Created by Gabriel Ferreira on 31/08/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import Foundation

class Wrapper: Codable {
    var results: [Movie]?
    var page: Int?
    var total_results: Int?
    var dates: Dates?
    var total_pages: Int?
    
    struct Dates: Codable {
        var maximum: String?
        var minimum: String?
    }
}
