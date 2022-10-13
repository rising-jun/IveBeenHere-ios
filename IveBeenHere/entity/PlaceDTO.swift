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
    
    func convertVisitEntity() -> VisitEntity {
        return VisitEntity(place: place, date: date, title: title, content: content, imageData: nil, userId: userId)
    }
}

struct PlaceDTO: Codable {
    let latitude: Double
    let name: String
    let longitude: Double
}

protocol VisitUsable {
    func getPlace() -> PlaceDTO
    func getDate() -> String
    func getTitle() -> String?
    func getContent() -> String?
    func getImageData() -> Data?
    func getUserId() -> String
}
class VisitEntity {
    let place: PlaceDTO
    let date: String
    let title: String?
    let content: String?
    private(set) var imageData: Data?
    let userId: String
    
    init(place: PlaceDTO, date: String, title: String?, content: String?, imageData: Data?, userId: String) {
        self.place = place
        self.date = date
        self.title = title
        self.content = content
        self.imageData = imageData
        self.userId = userId
    }
    func getPlace() -> PlaceDTO {
        return place
    }
    
    func getDate() -> String {
        return date
    }
    
    func getTitle() -> String? {
        return title
    }
    
    func getContent() -> String? {
        return content
    }
    
    func setImageData(from data: Data?) {
        self.imageData = data
    }
    
    func getUserId() -> String {
        return userId
    }
}
