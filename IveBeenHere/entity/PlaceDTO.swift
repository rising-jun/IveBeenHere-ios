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
        case placeDTOS = "PlaceDTO"
    }
}

struct VisitDTO: Codable {
    let place: PlaceDTO
    let date: Date
    let title: String?
    let content: String?
    let imageURL: String
}

struct PlaceDTO: Codable {
    let latitude: Double
    let name: String
    let longitude: Double
}
