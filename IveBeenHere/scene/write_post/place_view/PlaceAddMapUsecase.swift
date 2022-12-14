//
//  PlaceAddMapUsecase.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/27.
//

import Foundation

final class PlaceAddMapUsecase {
    var firebaseManagable: FirebaseManagable
    init() {
        firebaseManagable = FirebaseManager.shared
    }
}
extension PlaceAddMapUsecase: PlaceAddMapManagable {
    func requestAdd(place: PlaceDTO) {
        firebaseManagable.writePlaceDTO(placeDTO: place, completion: { result in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        })
    }
}

protocol PlaceAddMapManagable {
    func requestAdd(place: PlaceDTO)
}
