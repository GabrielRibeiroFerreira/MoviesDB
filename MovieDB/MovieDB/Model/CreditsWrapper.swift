//
//  CreditsWrapper.swift
//  MovieDB
//
//  Created by Gabriel Ferreira on 02/09/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import Foundation

class CreditsWrapper: Codable {
    var id: Int?
    var cast: [People]?
    var crew: [People]?
}
