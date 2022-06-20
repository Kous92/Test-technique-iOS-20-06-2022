//
//  ImageModel.swift
//  Test technique 20 juin 2022
//
//  Created by Koussaïla Ben Mamar on 20/06/2022.
//

import Foundation

struct ImageResult: Codable {
    var total, totalHits: Int
    var hits: [Hit]
}

struct Hit: Codable {
    var id: Int
    var previewURL: String?
    var largeImageURL: String?
}
