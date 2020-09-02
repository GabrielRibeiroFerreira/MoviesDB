//
//  Movie.swift
//  MovieDB
//
//  Created by Gabriel Ferreira on 31/08/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import Foundation

class Movie: Codable {
    var adult: Bool?
    var backdrop_path: String?
//    var belongs_to_collection: Collection?
    var budget: Int?
    var genres: [Genre]?
    var homepage: String?
    var id: Int?
    var imdb_id: String?
    var original_language: String?
    var original_title: String?
    var overview: String?
    var popularity: Float? //number
    var poster_path: String?
    var production_companies: [Company]?
    var production_countries: [Country]?
    var release_date: String?
    var revenue: Int?
    var runtime: Int?
    var spoken_languages: [Language]?
    var status: String? //Allowed Values: Rumored, Planned, In Production, Post Production, Released, Canceled
    var tagline: String?
    var title: String?
    var video: Bool?
    var vote_average: Float?
    var vote_count: Int?
}
