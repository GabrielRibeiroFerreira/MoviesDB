//
//  People.swift
//  MovieDB
//
//  Created by Gabriel Ferreira on 01/09/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import Foundation

class People: Codable {
    var birthday: String?
    var known_for_department: String?
    var deathday: String?
    var id: Int?
    var name: String?
    var also_known_as: [String]?
    var gender: Int?
    var biography: String?
    var popularity: Float?
    var place_of_birth: String?
    var profile_path: String?
    var adult: Bool?
    var imdb_id: String?
    var homepage: String?
    var character: String?
    var job: String?
}
