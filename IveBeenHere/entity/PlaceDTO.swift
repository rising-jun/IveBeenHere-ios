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

struct VisitSnap: Codable {
    let visitDTOs: [VisitDTO]
    
    enum CodingKeys: String, CodingKey {
        case visitDTOs = "VisitDTO"
    }
}

struct VisitDTO: Codable {
    let place: PlaceDTO
    let date: String
    let title: String?
    let content: String?
    let imageURL: String
    let userId: String
}

struct PlaceDTO: Codable {
    let latitude: Double
    let name: String
    let longitude: Double
}
