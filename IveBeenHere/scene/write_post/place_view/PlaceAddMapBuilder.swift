//
//  PlaceAddMapBuilder.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/27.
//

import Foundation

protocol PlaceAddMapBuildingLogic {
    typealias Destination = PlaceAddMapViewController
    func build() -> Destination
}

class PlaceAddMapBuilder: PlaceAddMapBuildingLogic {
    func build() -> Destination {
        let viewController = PlaceAddMapViewController.instance()
        let viewModel = PlaceAddMapViewModel()
        let mapUsecase = PlaceAddMapUsecase()
        
        viewController.viewModel = viewModel
        return viewController
    }
}
