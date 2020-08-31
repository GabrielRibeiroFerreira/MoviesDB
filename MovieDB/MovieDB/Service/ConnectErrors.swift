//
//  ConnectErrors.swift
//  MovieDB
//
//  Created by Gabriel Ferreira on 31/08/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import Foundation

enum ConnectErrors: Error {
    case receivedFailure
}

struct ErrorMessage : Codable {
    let code : Int
    let status : String
}
