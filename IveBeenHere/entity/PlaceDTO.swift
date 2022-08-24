//
//  PlaceDTO.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/24.
//

import Foundation

struct SnapInfo: Codable {
    let placeDTOS: [PlaceDTO]
    
    enum CodingKeys: String, CodingKey {
        case placeDTOS = "placeDTOs"
    }
}

struct PlaceDTO: Codable {
    let region: Region
    let latitude: Int
    let name: String
    let longitude: Int
}

struct Region: Codable {
    let city: [String]
}
